"""TMDB-парсер: каталог-справочник без потоков.

Использует публичное v3 REST API (https://api.themoviedb.org/3/) для
получения метаданных фильмов и сериалов: trending, поиск, детали с
сезонами и эпизодами. Потоки TMDB не предоставляет — `stream()` бросает
понятную ошибку, фронт показывает действия «скопировать название» и
«создать сеанс по ссылке».

API-ключ читается из SourceConfig в БД (с fallback'ом на settings).
"""

from __future__ import annotations

import logging
import threading
from typing import Optional

import httpx

from .. import config_loader
from ..dataclasses import (
    KIND_MOVIE,
    KIND_SERIES,
    Episode,
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

DEFAULT_BASE = 'https://api.themoviedb.org/3'
IMAGE_BASE = 'https://image.tmdb.org/t/p/w500'
LANGUAGE = 'ru-RU'


def _poster(path: Optional[str]) -> str:
    if not path:
        return ''
    return IMAGE_BASE + path


def _vote(payload: dict) -> Optional[float]:
    v = payload.get('vote_average')
    if v is None or v == 0:
        return None
    return round(float(v), 1)


def _year(date_str: Optional[str]) -> Optional[int]:
    if not date_str or len(date_str) < 4:
        return None
    try:
        return int(date_str[:4])
    except ValueError:
        return None


def _movie_to_title(item: dict) -> Title:
    return Title(
        id=f"m{item['id']}",
        title=item.get('title') or item.get('original_title') or '',
        year=_year(item.get('release_date')),
        kind=KIND_MOVIE,
        poster=_poster(item.get('poster_path')),
        rating=_vote(item),
        url=f"https://www.themoviedb.org/movie/{item['id']}",
    )


def _tv_to_title(item: dict) -> Title:
    return Title(
        id=f"t{item['id']}",
        title=item.get('name') or item.get('original_name') or '',
        year=_year(item.get('first_air_date')),
        kind=KIND_SERIES,
        poster=_poster(item.get('poster_path')),
        rating=_vote(item),
        url=f"https://www.themoviedb.org/tv/{item['id']}",
    )


def _split_id(external_id: str) -> tuple[str, int]:
    """external_id вида 'm12345' / 't67890' → (kind, numeric_id)."""
    if not external_id or len(external_id) < 2:
        raise TitleNotFoundError('Неверный идентификатор тайтла')
    prefix = external_id[0]
    rest = external_id[1:]
    if prefix not in ('m', 't') or not rest.isdigit():
        raise TitleNotFoundError('Неверный идентификатор тайтла')
    return prefix, int(rest)


class TMDBParser(CatalogParser):
    id = 'tmdb'
    label = 'TMDB'

    def __init__(self):
        self._client: Optional[httpx.Client] = None
        self._client_lock = threading.Lock()

    @property
    def available(self) -> bool:
        cfg = config_loader.get(self.id)
        # У SourceConfig в поле `password` фактически хранится API-ключ
        # (поле универсальное, см. admin.py).
        return cfg.is_active and bool(cfg.password)

    @property
    def base(self) -> str:
        cfg = config_loader.get(self.id)
        return (cfg.base_url or DEFAULT_BASE).rstrip('/')

    @property
    def api_key(self) -> str:
        return config_loader.get(self.id).password

    def _get_client(self) -> httpx.Client:
        with self._client_lock:
            if self._client is None:
                self._client = httpx.Client(
                    timeout=10.0,
                    headers={'Accept': 'application/json'},
                )
            return self._client

    def _get(self, path: str, params: Optional[dict] = None) -> dict:
        if not self.api_key:
            raise ParserUnavailableError(
                'TMDB API-ключ не задан. Добавьте его в /admin/ → '
                'Источники каталога.'
            )
        full_params = {'api_key': self.api_key, 'language': LANGUAGE}
        if params:
            full_params.update(params)
        url = f'{self.base}{path}'
        try:
            r = self._get_client().get(url, params=full_params)
        except Exception as exc:
            raise ParserUnavailableError(f'TMDB не отвечает: {exc}') from exc
        if r.status_code == 401:
            raise ParserUnavailableError('TMDB отверг ключ (401) — проверьте API-ключ')
        if r.status_code == 404:
            raise TitleNotFoundError('Тайтл не найден в TMDB')
        if r.status_code >= 500:
            raise ParserUnavailableError(f'TMDB вернул {r.status_code}')
        if r.status_code >= 400:
            raise ParserUnavailableError(f'TMDB вернул {r.status_code}: {r.text[:200]}')
        return r.json()

    # -- Публичные методы --------------------------------------------------

    def feed(self, page: int = 1, kind: Optional[str] = None) -> Page:
        page = max(1, min(page, 500))  # TMDB лимит — 500 страниц
        if kind == KIND_SERIES:
            data = self._get('/trending/tv/week', {'page': page})
            items = [_tv_to_title(x) for x in data.get('results', [])]
        else:
            data = self._get('/trending/movie/week', {'page': page})
            items = [_movie_to_title(x) for x in data.get('results', [])]
        return Page(
            items=items,
            page=page,
            has_next=page < int(data.get('total_pages') or 1),
        )

    def search(self, query: str, page: int = 1) -> Page:
        page = max(1, min(page, 500))
        data = self._get('/search/multi', {'query': query, 'page': page})
        items = []
        for x in data.get('results', []):
            mt = x.get('media_type')
            if mt == 'movie':
                items.append(_movie_to_title(x))
            elif mt == 'tv':
                items.append(_tv_to_title(x))
            # person и прочее отбрасываем
        return Page(
            items=items,
            page=page,
            has_next=page < int(data.get('total_pages') or 1),
        )

    def title(self, external_id: str) -> TitleDetails:
        prefix, tmdb_id = _split_id(external_id)
        if prefix == 'm':
            data = self._get(f'/movie/{tmdb_id}')
            return TitleDetails(
                id=external_id,
                title=data.get('title') or data.get('original_title') or '',
                year=_year(data.get('release_date')),
                kind=KIND_MOVIE,
                poster=_poster(data.get('poster_path')),
                rating=_vote(data),
                url=f'https://www.themoviedb.org/movie/{tmdb_id}',
                description=data.get('overview') or '',
                genres=[g.get('name', '') for g in (data.get('genres') or [])],
                duration_minutes=data.get('runtime') or None,
                seasons=[],
            )
        # TV
        data = self._get(f'/tv/{tmdb_id}')
        seasons: list[Season] = []
        for s in data.get('seasons') or []:
            # TMDB включает «сезон 0 / Специальные выпуски» — пропускаем.
            sn = s.get('season_number')
            if sn is None or sn == 0:
                continue
            try:
                sdata = self._get(f'/tv/{tmdb_id}/season/{sn}')
            except (ParserUnavailableError, TitleNotFoundError):
                continue
            episodes = [
                Episode(number=ep.get('episode_number') or 0,
                        title=ep.get('name') or '')
                for ep in (sdata.get('episodes') or [])
                if ep.get('episode_number')
            ]
            seasons.append(Season(number=sn, episodes=episodes))
        return TitleDetails(
            id=external_id,
            title=data.get('name') or data.get('original_name') or '',
            year=_year(data.get('first_air_date')),
            kind=KIND_SERIES,
            poster=_poster(data.get('poster_path')),
            rating=_vote(data),
            url=f'https://www.themoviedb.org/tv/{tmdb_id}',
            description=data.get('overview') or '',
            genres=[g.get('name', '') for g in (data.get('genres') or [])],
            duration_minutes=None,
            seasons=seasons,
        )

    def stream(self, external_id, season=None, episode=None) -> Stream:
        raise StreamUnavailableError(
            'TMDB — справочник без потоков. Скопируйте название и создайте '
            '«Сеанс по ссылке» с нужного источника.'
        )
