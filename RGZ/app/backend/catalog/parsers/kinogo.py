"""Парсер kinogo (DLE-сайт).

Каталог парсится из HTML; для извлечения прямого потока сначала пробуем
`yt-dlp` (он знает множество встроенных плееров), при провале отдаём
embed-URL — фронт нарисует его iframe-ом (тогда синхронный просмотр в
комнате недоступен, но «смотреть здесь» работает).

Базовый домен меняется через env `KINOGO_BASE` — при блокировке достаточно
получить новое зеркало в Telegram-боте @kinogobiz_bot и поменять переменную.
"""

from __future__ import annotations

import logging
import re
import threading
from typing import Optional
from urllib.parse import urljoin, urlparse

import httpx
from selectolax.parser import HTMLParser

from .. import config_loader
from ..dataclasses import (
    KIND_MOVIE,
    KIND_SERIES,
    STREAM_HLS,
    STREAM_MP4,
    Page,
    Season,
    Stream,
    Title,
    TitleDetails,
)
from ..errors import (
    ParserUnavailableError,
    StreamUnavailableError,
    TitleNotFoundError,
)
from .base import CatalogParser

logger = logging.getLogger(__name__)

UA = (
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 '
    '(KHTML, like Gecko) Chrome/121.0 Safari/537.36'
)


def _resolve_url(base: str, raw: str) -> str:
    """Превращает //host/path или относительный путь в абсолютный URL."""
    if not raw:
        return ''
    if raw.startswith('//'):
        return 'https:' + raw
    if raw.startswith('http://') or raw.startswith('https://'):
        return raw
    return urljoin(base + '/', raw.lstrip('/'))


def _parse_year(text: str) -> Optional[int]:
    """Извлекает 4-значный год из строки вида 'Название (2025) ...'."""
    m = re.search(r'\((\d{4})\)', text)
    return int(m.group(1)) if m else None


def _strip_year_suffix(title: str) -> str:
    """Убирает хвост ' смотреть онлайн ...' из og:title — оставляет «Название (2025)»."""
    cut = title.lower().find(' смотреть')
    return title[:cut].strip() if cut > 0 else title.strip()


class KinogoParser(CatalogParser):
    id = 'kinogo'
    label = 'Kinogo'

    def __init__(self):
        self._client: Optional[httpx.Client] = None
        self._client_base: str = ''
        self._client_lock = threading.Lock()
        self._login_state: dict[tuple[str, str], bool] = {}

    # -- HTTP клиент с авто-логином ------------------------------------------

    @property
    def base(self) -> str:
        return config_loader.get(self.id).base_url or 'https://kinogo.la'

    def _get_client(self) -> httpx.Client:
        """Возвращает httpx.Client, привязанный к текущему base. Если base
        поменялся через админку — пересоздаём (старые куки чужого домена
        нам не нужны)."""
        base = self.base
        with self._client_lock:
            if self._client is None or self._client_base != base:
                if self._client is not None:
                    try:
                        self._client.close()
                    except Exception:
                        pass
                self._client = httpx.Client(
                    headers={
                        'User-Agent': UA,
                        'Accept-Language': 'ru-RU,ru;q=0.9',
                        'Referer': base + '/',
                    },
                    timeout=15.0,
                    follow_redirects=True,
                )
                self._client_base = base
                self._login_state.clear()
            return self._client

    def _ensure_login(self) -> None:
        """Логинится один раз на пару (base, login). При смене зеркала или
        смене учётки — повторяет вход."""
        cfg = config_loader.get(self.id)
        key = (self._client_base or self.base, cfg.username)
        if self._login_state.get(key) or not cfg.username or not cfg.password:
            self._login_state[key] = True
            return
        client = self._get_client()
        try:
            client.post(
                cfg.base_url or self.base,
                data={
                    'login_name': cfg.username,
                    'login_password': cfg.password,
                    'login_not_save': '1',
                    'login': 'submit',
                },
            )
        except Exception as exc:
            logger.warning('kinogo: не удалось залогиниться (%s) — работаем без аккаунта', exc)
        self._login_state[key] = True

    def _fetch(self, path_or_url: str) -> str:
        """GET к kinogo с учётом куки-сессии. Возвращает HTML или бросает."""
        self._ensure_login()
        url = path_or_url if path_or_url.startswith('http') else urljoin(self.base + '/', path_or_url.lstrip('/'))
        client = self._get_client()
        try:
            r = client.get(url)
        except Exception as exc:
            raise ParserUnavailableError(f'kinogo не отвечает: {exc}') from exc
        if r.status_code >= 500:
            raise ParserUnavailableError(f'kinogo вернул {r.status_code}')
        if r.status_code == 404:
            raise TitleNotFoundError('Страница не найдена')
        return r.text

    # -- Парсинг карточки в ленте/поиске -------------------------------------

    def _parse_cards(self, html: str) -> list[Title]:
        dom = HTMLParser(html)
        cards = dom.css('div.movie[id]')
        titles: list[Title] = []
        for card in cards:
            ext_id = card.attributes.get('id') or ''
            link = card.css_first('h2.zagolovki a, .shortstorytitle a')
            if not link:
                continue
            url = link.attributes.get('href') or ''
            name = link.text(strip=True)
            year = _parse_year(name)
            # postеr
            img = card.css_first('.movie__info-img img, img.lazy, img[src]')
            poster_raw = ''
            if img is not None:
                poster_raw = (
                    img.attributes.get('data-src')
                    or img.attributes.get('data-lazy-src')
                    or img.attributes.get('src')
                    or ''
                )
            # rating: ширина .current-rating в процентах → 0..5
            rating: Optional[float] = None
            rating_el = card.css_first('.current-rating')
            if rating_el is not None:
                style = rating_el.attributes.get('style') or ''
                m = re.search(r'width:\s*(\d+)\s*%', style)
                if m:
                    rating = round(int(m.group(1)) / 20.0, 2)  # 100% → 5.0
            # kind: kinogo помечает сериалы тегами/классами; для простоты определяем по
            # категории в href (/serialy/) — иначе фильм.
            kind = KIND_SERIES if '/serialy/' in url else KIND_MOVIE
            titles.append(Title(
                id=ext_id,
                title=_strip_year_suffix(name),
                year=year,
                kind=kind,
                poster=_resolve_url(self.base, poster_raw),
                rating=rating,
                url=url,
            ))
        return titles

    def _has_next_page(self, dom: HTMLParser, current_page: int) -> bool:
        """Грубо: ищем ссылку на следующую страницу в навигации."""
        nav = dom.css_first('.navigation, .basenavi')
        if nav is None:
            return False
        # ссылки вида /page/3/ или ?cstart=
        for a in nav.css('a'):
            href = a.attributes.get('href') or ''
            m = re.search(r'/page/(\d+)/', href) or re.search(r'cstart=(\d+)', href)
            if m and int(m.group(1)) > current_page:
                return True
        return False

    # -- Публичные методы ----------------------------------------------------

    def feed(self, page: int = 1, kind: Optional[str] = None) -> Page:
        path = '/' if page == 1 else f'/page/{page}/'
        # Если запросили только сериалы — берём их раздел.
        if kind == KIND_SERIES:
            path = '/serialy/' if page == 1 else f'/serialy/page/{page}/'
        elif kind == KIND_MOVIE:
            path = '/filmy/' if page == 1 else f'/filmy/page/{page}/'
        html = self._fetch(path)
        items = self._parse_cards(html)
        return Page(items=items, page=page, has_next=self._has_next_page(HTMLParser(html), page))

    def search(self, query: str, page: int = 1) -> Page:
        client = self._get_client()
        self._ensure_login()
        try:
            r = client.post(
                self.base + '/',
                data={
                    'do': 'search',
                    'subaction': 'search',
                    'story': query,
                    'search_start': str(page),
                },
                headers={'Content-Type': 'application/x-www-form-urlencoded'},
            )
        except Exception as exc:
            raise ParserUnavailableError(f'kinogo поиск упал: {exc}') from exc
        items = self._parse_cards(r.text)
        return Page(items=items, page=page, has_next=self._has_next_page(HTMLParser(r.text), page))

    def title(self, external_id: str) -> TitleDetails:
        # Открываем страницу через короткий URL поиска по ID: /xxxxx-anything.html.
        # У DLE достаточно префикса /<id>-, остальное он не проверяет.
        # Однако для надёжности используем редирект через /go/<id> если есть, иначе
        # пробуем получить slug из feed-карточки — но обычно у нас уже есть Title.url
        # сохранённый из feed. Здесь — если получили только id, делаем GET страницы поиска.
        html = self._fetch(f'/{external_id}-.html')
        return self._parse_title(html, external_id)

    def title_by_url(self, external_id: str, url: str) -> TitleDetails:
        html = self._fetch(url)
        return self._parse_title(html, external_id)

    def _parse_title(self, html: str, external_id: str) -> TitleDetails:
        dom = HTMLParser(html)
        og_title = dom.css_first('meta[property="og:title"]')
        og_image = dom.css_first('meta[property="og:image"]')
        og_descr = dom.css_first('meta[property="og:description"]')
        title_full = (og_title.attributes.get('content') if og_title else '') or ''
        name = _strip_year_suffix(title_full)
        year = _parse_year(title_full)
        poster = (og_image.attributes.get('content') if og_image else '') or ''
        description = (og_descr.attributes.get('content') if og_descr else '') or ''

        # Тип контента — определяем по iframe-URL или по breadcrumbs.
        iframe = dom.css_first('iframe[src]')
        iframe_src = (iframe.attributes.get('src') if iframe else '') or ''
        is_series = bool(re.search(r'/(serial|series|tv|show)s?/', iframe_src, re.I))

        return TitleDetails(
            id=external_id,
            title=name,
            year=year,
            kind=KIND_SERIES if is_series else KIND_MOVIE,
            poster=_resolve_url(self.base, poster),
            description=description,
            url=self.base + f'/{external_id}-.html',
            seasons=[],  # глубокий разбор сезонов у kinogo требует доступа к плееру
        )

    def stream(
        self,
        external_id: str,
        season: Optional[int] = None,
        episode: Optional[int] = None,
    ) -> Stream:
        """Возвращает Stream. Сначала пробуем yt-dlp на iframe-URL, при неудаче
        отдаём embed-iframe — фронт нарисует его как `<iframe>`."""
        # Достаём iframe-URL со страницы тайтла.
        html = self._fetch(f'/{external_id}-.html')
        dom = HTMLParser(html)
        iframe = dom.css_first('iframe[src]')
        if iframe is None:
            raise StreamUnavailableError('Плеер не найден на странице тайтла')
        iframe_src = _resolve_url(self.base, iframe.attributes.get('src') or '')

        og_title_el = dom.css_first('meta[property="og:title"]')
        og_image_el = dom.css_first('meta[property="og:image"]')
        display_title = _strip_year_suffix((og_title_el.attributes.get('content') if og_title_el else '') or '')
        thumbnail = (og_image_el.attributes.get('content') if og_image_el else '') or ''

        # Попытка №1: yt-dlp умеет много встроенных плееров.
        try:
            import yt_dlp

            ydl_opts = {
                'quiet': True,
                'no_warnings': True,
                'format': 'best[ext=mp4][protocol^=http]/best[ext=mp4]/best',
                'socket_timeout': 12,
                'retries': 1,
                'http_headers': {'Referer': self.base + '/'},
            }
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                info = ydl.extract_info(iframe_src, download=False)
            if info and info.get('_type') == 'playlist' and info.get('entries'):
                info = info['entries'][0]
            stream_url = info.get('url') if info else ''
            if stream_url:
                kind = STREAM_HLS if '.m3u8' in stream_url else STREAM_MP4
                return Stream(
                    url=stream_url,
                    kind=kind,
                    title=display_title,
                    thumbnail=thumbnail,
                    duration=info.get('duration'),
                )
        except Exception as exc:
            logger.info('kinogo stream: yt-dlp не сработал (%s) — отдаю embed-URL', exc)

        # Fallback: фронт нарисует iframe.
        return Stream(
            url=iframe_src,
            kind='embed',
            title=display_title,
            thumbnail=thumbnail,
        )
