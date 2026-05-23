"""Тесты каталога: API endpoint'ы с мок-парсером."""

import pytest
from rest_framework.test import APIClient

from catalog import cache as ccache
from catalog import config_loader
from catalog.dataclasses import KIND_MOVIE, Page, Stream, Title, TitleDetails
from catalog.errors import ParserUnavailableError
from catalog.parsers import _PARSERS
from catalog.parsers.base import CatalogParser


class _MockParser(CatalogParser):
    id = 'kinogo'
    label = 'Kinogo'

    def __init__(self, *, raise_unavail=False):
        self._raise = raise_unavail

    def feed(self, page=1, kind=None):
        if self._raise:
            raise ParserUnavailableError('mirror dead')
        return Page(items=[Title(id='1', title='Тестовый фильм', year=2024)], page=page, has_next=False)

    def search(self, query, page=1):
        return Page(items=[Title(id='1', title=f'Search {query}', year=2024)], page=page)

    def title(self, external_id):
        return TitleDetails(id=external_id, title='Подробности', year=2024, kind=KIND_MOVIE)

    def stream(self, external_id, season=None, episode=None):
        return Stream(url='https://cdn.example.com/v.mp4', kind='mp4', title='movie')


@pytest.fixture(autouse=True)
def clear_cache():
    """Перед каждым тестом — чистый кеш парсеров и конфигов."""
    ccache._memory_cache._data.clear()
    config_loader.invalidate()
    yield


@pytest.fixture
def mock_kinogo(monkeypatch):
    """Подменяет зарегистрированный kinogo на мок."""
    parser = _MockParser()
    monkeypatch.setitem(_PARSERS, 'kinogo', parser)
    return parser


@pytest.mark.django_db
def test_sources_endpoint(mock_kinogo):
    resp = APIClient().get('/api/catalog/sources/')
    assert resp.status_code == 200
    ids = {s['id'] for s in resp.json()['sources']}
    assert 'kinogo' in ids
    assert 'zona' in ids


@pytest.mark.django_db
def test_feed_returns_titles(mock_kinogo):
    resp = APIClient().get('/api/catalog/kinogo/feed/')
    assert resp.status_code == 200
    body = resp.json()
    assert body['items'][0]['title'] == 'Тестовый фильм'
    assert body['page'] == 1


@pytest.mark.django_db
def test_feed_503_when_parser_unavailable(monkeypatch):
    monkeypatch.setitem(_PARSERS, 'kinogo', _MockParser(raise_unavail=True))
    resp = APIClient().get('/api/catalog/kinogo/feed/')
    assert resp.status_code == 503


@pytest.mark.django_db
def test_search_requires_q(mock_kinogo):
    resp = APIClient().get('/api/catalog/kinogo/search/')
    assert resp.status_code == 400


@pytest.mark.django_db
def test_search_returns_results(mock_kinogo):
    resp = APIClient().get('/api/catalog/kinogo/search/?q=batman')
    assert resp.status_code == 200
    assert resp.json()['items'][0]['title'] == 'Search batman'


@pytest.mark.django_db
def test_title_and_stream(mock_kinogo):
    t = APIClient().get('/api/catalog/kinogo/title/42/')
    assert t.status_code == 200
    assert t.json()['id'] == '42'

    s = APIClient().get('/api/catalog/kinogo/stream/42/')
    assert s.status_code == 200
    assert s.json()['url'].endswith('.mp4')


@pytest.mark.django_db
def test_zona_unavailable():
    resp = APIClient().get('/api/catalog/zona/feed/')
    assert resp.status_code == 503


@pytest.mark.django_db
def test_unknown_source_404():
    resp = APIClient().get('/api/catalog/qwe/feed/')
    assert resp.status_code == 404
