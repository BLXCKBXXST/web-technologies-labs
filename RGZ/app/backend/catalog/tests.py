"""Тесты каталога: API endpoint'ы с мок-парсером + TMDBParser через httpx mock."""

import httpx
import pytest
from rest_framework.test import APIClient

from catalog import cache as ccache
from catalog import config_loader
from catalog.config_loader import SourceSettings
from catalog.dataclasses import KIND_MOVIE, KIND_SERIES, Page, Stream, Title, TitleDetails
from catalog.errors import ParserUnavailableError, StreamUnavailableError
from catalog.parsers import _PARSERS
from catalog.parsers.base import CatalogParser
from catalog.parsers.tmdb import TMDBParser


class _MockParser(CatalogParser):
    id = 'tmdb'
    label = 'TMDB'

    def __init__(self, *, raise_unavail=False):
        self._raise = raise_unavail

    def feed(self, page=1, kind=None):
        if self._raise:
            raise ParserUnavailableError('TMDB недоступен')
        return Page(
            items=[Title(id='m1', title='Тестовый фильм', year=2024, kind=KIND_MOVIE)],
            page=page,
            has_next=False,
        )

    def search(self, query, page=1):
        return Page(
            items=[Title(id='m2', title=f'Search {query}', year=2024, kind=KIND_MOVIE)],
            page=page,
        )

    def title(self, external_id):
        return TitleDetails(id=external_id, title='Подробности', year=2024, kind=KIND_MOVIE)

    def stream(self, external_id, season=None, episode=None):
        raise StreamUnavailableError('TMDB — справочник без потоков')


@pytest.fixture(autouse=True)
def clear_cache():
    ccache._memory_cache._data.clear()
    config_loader.invalidate()
    yield


@pytest.fixture
def mock_tmdb(monkeypatch):
    parser = _MockParser()
    monkeypatch.setitem(_PARSERS, 'tmdb', parser)
    return parser


# --- API endpoints ----------------------------------------------------------

@pytest.mark.django_db
def test_sources_endpoint_lists_tmdb(mock_tmdb):
    resp = APIClient().get('/api/catalog/sources/')
    assert resp.status_code == 200
    ids = {s['id'] for s in resp.json()['sources']}
    assert ids == {'tmdb'}


@pytest.mark.django_db
def test_feed_returns_titles(mock_tmdb):
    resp = APIClient().get('/api/catalog/tmdb/feed/')
    assert resp.status_code == 200
    body = resp.json()
    assert body['items'][0]['title'] == 'Тестовый фильм'


@pytest.mark.django_db
def test_feed_503_when_parser_unavailable(monkeypatch):
    monkeypatch.setitem(_PARSERS, 'tmdb', _MockParser(raise_unavail=True))
    resp = APIClient().get('/api/catalog/tmdb/feed/')
    assert resp.status_code == 503


@pytest.mark.django_db
def test_search_requires_q(mock_tmdb):
    resp = APIClient().get('/api/catalog/tmdb/search/')
    assert resp.status_code == 400


@pytest.mark.django_db
def test_search_returns_results(mock_tmdb):
    resp = APIClient().get('/api/catalog/tmdb/search/?q=batman')
    assert resp.status_code == 200
    assert resp.json()['items'][0]['title'] == 'Search batman'


@pytest.mark.django_db
def test_title_returns_details(mock_tmdb):
    resp = APIClient().get('/api/catalog/tmdb/title/m42/')
    assert resp.status_code == 200
    assert resp.json()['id'] == 'm42'


@pytest.mark.django_db
def test_stream_502_for_tmdb(mock_tmdb):
    resp = APIClient().get('/api/catalog/tmdb/stream/m42/')
    assert resp.status_code == 502


@pytest.mark.django_db
def test_unknown_source_404(mock_tmdb):
    resp = APIClient().get('/api/catalog/qwe/feed/')
    assert resp.status_code == 404


# --- TMDBParser изолированно (через httpx MockTransport) --------------------

def _make_tmdb(monkeypatch, handler):
    """Подменяет httpx-клиент TMDBParser и SourceSettings (есть API-ключ)."""
    monkeypatch.setattr(
        config_loader, 'get',
        lambda _id: SourceSettings(
            base_url='https://api.themoviedb.org/3', username='',
            password='test-key', is_active=True,
        ),
    )
    parser = TMDBParser()
    transport = httpx.MockTransport(handler)
    parser._client = httpx.Client(transport=transport, timeout=5.0)
    return parser


def test_tmdb_feed_parses_trending(monkeypatch):
    def handler(request):
        assert request.url.path == '/3/trending/movie/week'
        assert request.url.params['api_key'] == 'test-key'
        return httpx.Response(200, json={
            'page': 1, 'total_pages': 5,
            'results': [
                {'id': 100, 'title': 'Фильм A', 'release_date': '2024-05-01',
                 'poster_path': '/a.jpg', 'vote_average': 7.4},
                {'id': 101, 'title': 'Фильм B', 'release_date': '',
                 'poster_path': None, 'vote_average': 0},
            ],
        })
    parser = _make_tmdb(monkeypatch, handler)
    page = parser.feed(page=1)
    assert page.has_next is True
    assert len(page.items) == 2
    assert page.items[0].id == 'm100'
    assert page.items[0].title == 'Фильм A'
    assert page.items[0].year == 2024
    assert page.items[0].rating == 7.4
    assert page.items[0].poster.startswith('https://image.tmdb.org/t/p/w500/a.jpg')
    assert page.items[1].rating is None
    assert page.items[1].year is None


def test_tmdb_search_filters_persons(monkeypatch):
    def handler(request):
        assert request.url.path == '/3/search/multi'
        return httpx.Response(200, json={
            'page': 1, 'total_pages': 1,
            'results': [
                {'id': 1, 'title': 'Кино', 'media_type': 'movie',
                 'release_date': '2024-01-01', 'poster_path': '/x.jpg', 'vote_average': 6},
                {'id': 2, 'name': 'Сериал', 'media_type': 'tv',
                 'first_air_date': '2023-01-01', 'poster_path': '/y.jpg', 'vote_average': 8},
                {'id': 3, 'name': 'Артист', 'media_type': 'person'},
            ],
        })
    parser = _make_tmdb(monkeypatch, handler)
    page = parser.search('test')
    assert [t.id for t in page.items] == ['m1', 't2']
    assert page.items[1].kind == KIND_SERIES


def test_tmdb_stream_unavailable(monkeypatch):
    def handler(request):
        return httpx.Response(200, json={})
    parser = _make_tmdb(monkeypatch, handler)
    with pytest.raises(StreamUnavailableError):
        parser.stream('m1')


def test_tmdb_missing_api_key(monkeypatch):
    monkeypatch.setattr(
        config_loader, 'get',
        lambda _id: SourceSettings(
            base_url='https://api.themoviedb.org/3', username='',
            password='', is_active=True,
        ),
    )
    parser = TMDBParser()
    with pytest.raises(ParserUnavailableError):
        parser.feed()
