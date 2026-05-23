"""Парсер Zona — пока заглушка.

У сервиса несколько доменов мигрируют (zona.media, zona.plus и т.п.); их
JSON-API реверсили на 4pda и в open-source клиентах. Чтобы не блокировать
выкатку каталога kinogo, здесь возвращается ParserUnavailableError, а UI
показывает плашку «временно недоступен». Реальный клиент можно добавить
позже.
"""

from __future__ import annotations

from typing import Optional

from ..dataclasses import Page, Stream, TitleDetails
from ..errors import ParserUnavailableError
from .base import CatalogParser


class ZonaParser(CatalogParser):
    id = 'zona'
    label = 'Zona'
    available = False

    def _unavailable(self):
        return ParserUnavailableError(
            'Источник Zona временно отключён: домен и API в процессе восстановления. '
            'Уточните актуальный домен и пропишите его в /admin/.'
        )

    def feed(self, page: int = 1, kind: Optional[str] = None) -> Page:
        raise self._unavailable()

    def search(self, query: str, page: int = 1) -> Page:
        raise self._unavailable()

    def title(self, external_id: str) -> TitleDetails:
        raise self._unavailable()

    def stream(self, external_id, season=None, episode=None) -> Stream:
        raise self._unavailable()
