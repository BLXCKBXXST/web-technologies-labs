"""Тесты комнат: чистая логика синхронизации, REST и WebSocket-консьюмер."""

from datetime import timedelta

import pytest
from channels.db import database_sync_to_async
from channels.testing import WebsocketCommunicator
from django.core.files.uploadedfile import SimpleUploadedFile
from django.utils import timezone
from rest_framework.test import APIClient
from rest_framework_simplejwt.tokens import RefreshToken

from accounts.models import User
from config.asgi import application
from rooms.models import WatchRoom
from rooms.sync import effective_position
from videos.models import Video


# --- Чистая функция синхронизации (ядро ключевой фичи) ----------------------

def test_effective_position_paused_is_frozen():
    now = timezone.now()
    earlier = now - timedelta(seconds=30)
    # На паузе позиция не зависит от прошедшего времени.
    assert effective_position(False, 42.0, earlier, now) == 42.0


def test_effective_position_playing_advances_with_time():
    now = timezone.now()
    started = now - timedelta(seconds=10)
    # За 10 секунд воспроизведения позиция выросла на 10.
    assert effective_position(True, 5.0, started, now) == pytest.approx(15.0, abs=0.01)


def test_effective_position_never_goes_backwards():
    now = timezone.now()
    future = now + timedelta(seconds=5)
    # Рассинхрон часов не должен уводить позицию назад.
    assert effective_position(True, 8.0, future, now) == 8.0


# --- Фикстуры ---------------------------------------------------------------

@pytest.fixture
def host_user():
    return User.objects.create_user(
        username='host', password='hostpass123',
        first_name='Хост', last_name='Ведущий',
    )


@pytest.fixture
def video(host_user, settings, tmp_path):
    settings.MEDIA_ROOT = str(tmp_path)
    return Video.objects.create(
        owner=host_user,
        title='Тестовое видео',
        file=SimpleUploadedFile('v.mp4', b'\x00' * 1024, content_type='video/mp4'),
        size_bytes=1024,
    )


@pytest.fixture
def auth(host_user):
    client = APIClient()
    token = RefreshToken.for_user(host_user).access_token
    client.credentials(HTTP_AUTHORIZATION=f'Bearer {token}')
    return client


# --- REST комнат ------------------------------------------------------------

@pytest.mark.django_db
def test_create_room_requires_authentication(video):
    resp = APIClient().post('/api/rooms/', {'video': str(video.id)}, format='json')
    assert resp.status_code == 401


@pytest.mark.django_db
def test_create_room_returns_room_with_video(auth, video):
    resp = auth.post(
        '/api/rooms/',
        {'video': str(video.id), 'title': 'Смотрим вместе'},
        format='json',
    )
    assert resp.status_code == 201
    body = resp.json()
    assert body['title'] == 'Смотрим вместе'
    assert body['video']['id'] == str(video.id)
    assert body['is_host'] is True
    assert body['participants_count'] == 0


@pytest.mark.django_db
def test_retrieve_room_is_public(auth, video):
    room_id = auth.post('/api/rooms/', {'video': str(video.id)}, format='json').json()['id']
    # Гость без токена открывает комнату по ссылке.
    resp = APIClient().get(f'/api/rooms/{room_id}/')
    assert resp.status_code == 200
    assert resp.json()['is_host'] is False


# --- WebSocket-консьюмер комнаты --------------------------------------------

def _ws_url(room_id, token=None):
    url = f'/ws/rooms/{room_id}/'
    return f'{url}?token={token}' if token else url


async def _make_room(video, host):
    return await database_sync_to_async(WatchRoom.objects.create)(video=video, host=host)


@pytest.mark.django_db(transaction=True)
async def test_room_socket_sends_initial_state(host_user, video):
    room = await _make_room(video, host_user)
    token = str(RefreshToken.for_user(host_user).access_token)
    communicator = WebsocketCommunicator(application, _ws_url(room.id, token))
    connected, _ = await communicator.connect()
    assert connected

    state = await communicator.receive_json_from()
    assert state['type'] == 'room.state'
    assert state['is_playing'] is False
    assert state['position'] == 0.0
    await communicator.disconnect()


@pytest.mark.django_db(transaction=True)
async def test_host_play_broadcasts_state(host_user, video):
    room = await _make_room(video, host_user)
    token = str(RefreshToken.for_user(host_user).access_token)
    communicator = WebsocketCommunicator(application, _ws_url(room.id, token))
    await communicator.connect()
    await communicator.receive_json_from()  # начальное room.state
    await communicator.receive_json_from()  # room.participants

    await communicator.send_json_to(
        {'type': 'player.play', 'position': 17.5, 'is_playing': True}
    )
    broadcast = await communicator.receive_json_from()
    assert broadcast['type'] == 'room.state'
    assert broadcast['is_playing'] is True
    assert broadcast['position'] == pytest.approx(17.5, abs=0.5)
    await communicator.disconnect()


@pytest.mark.django_db(transaction=True)
async def test_guest_cannot_control_playback(host_user, video):
    room = await _make_room(video, host_user)
    # Гость подключается без токена — он не ведущий.
    communicator = WebsocketCommunicator(application, _ws_url(room.id))
    await communicator.connect()
    await communicator.receive_json_from()  # начальное room.state
    await communicator.receive_json_from()  # room.participants

    await communicator.send_json_to(
        {'type': 'player.play', 'position': 50.0, 'is_playing': True}
    )
    await communicator.send_json_to({'type': 'player.sync_request'})
    state = await communicator.receive_json_from()
    # Команда гостя проигнорирована — комната всё ещё на паузе в начале.
    assert state['is_playing'] is False
    assert state['position'] == 0.0
    await communicator.disconnect()
