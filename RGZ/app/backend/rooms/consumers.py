"""WebSocket-консьюмер комнаты совместного просмотра.

Один сокет на участника. На этапе M3 обслуживает синхронизацию плеера и список
участников; на M4 расширяется чатом и вкладкой «Вопрос/ответ».

Авторитет состояния плеера — ведущий: команды play/pause/seek принимаются только
от него, остальным рассылается итоговое состояние комнаты.
"""

from channels.db import database_sync_to_async
from channels.generic.websocket import AsyncJsonWebsocketConsumer
from django.utils import timezone

from .models import RoomParticipant, WatchRoom
from .sync import effective_position


def state_payload(room):
    """Снимок состояния плеера комнаты для отправки клиентам."""
    now = timezone.now()
    position = effective_position(
        room.is_playing, room.playback_position, room.state_updated_at, now
    )
    return {
        'type': 'room.state',
        'is_playing': room.is_playing,
        'position': round(position, 3),
        'server_time': now.timestamp(),
    }


class RoomConsumer(AsyncJsonWebsocketConsumer):
    """Сокет одной комнаты. Группа канала — room_<uuid>."""

    HOST_ACTIONS = {'player.play', 'player.pause', 'player.seek'}

    async def connect(self):
        self.room_id = str(self.scope['url_route']['kwargs']['room_id'])
        self.group_name = f'room_{self.room_id}'
        self.user = self.scope['user']
        self.participant_id = None
        self.joined = False

        room = await self._get_room()
        if room is None:
            await self.close()
            return

        self.is_host = self.user.is_authenticated and self.user.id == room.host_id
        await self.channel_layer.group_add(self.group_name, self.channel_name)
        await self.accept()
        self.joined = True

        await self._join_participant(room)
        # Новому участнику — сразу текущее состояние плеера.
        await self.send_json(state_payload(room))
        await self._broadcast_participants()

    async def disconnect(self, code):
        if not getattr(self, 'joined', False):
            return
        await self._leave_participant()
        await self.channel_layer.group_discard(self.group_name, self.channel_name)
        await self._broadcast_participants()

    async def receive_json(self, content, **kwargs):
        message_type = content.get('type')
        if message_type in self.HOST_ACTIONS:
            # Управлять плеером может только ведущий.
            if self.is_host:
                await self._apply_host_action(message_type, content)
        elif message_type == 'player.sync_request':
            room = await self._get_room()
            if room is not None:
                await self.send_json(state_payload(room))

    # --- Рассылка по группе комнаты ---
    async def room_broadcast(self, event):
        """Обработчик group_send: пересылает готовый payload клиенту."""
        await self.send_json(event['payload'])

    async def _group_send(self, payload):
        await self.channel_layer.group_send(
            self.group_name, {'type': 'room.broadcast', 'payload': payload}
        )

    async def _apply_host_action(self, message_type, content):
        position = float(content.get('position') or 0.0)
        # Ведущий присылает фактическое состояние; seek не должен снимать паузу.
        is_playing = bool(content.get('is_playing', message_type != 'player.pause'))
        room = await self._update_room_state(position, is_playing)
        await self._group_send(state_payload(room))

    async def _broadcast_participants(self):
        await self._group_send(await self._participants_payload())

    # --- Доступ к БД (синхронный код в отдельном потоке) ---
    @database_sync_to_async
    def _get_room(self):
        return WatchRoom.objects.filter(pk=self.room_id, is_active=True).first()

    @database_sync_to_async
    def _update_room_state(self, position, is_playing):
        room = WatchRoom.objects.get(pk=self.room_id)
        room.playback_position = max(0.0, position)
        room.is_playing = is_playing
        room.state_updated_at = timezone.now()
        room.save(
            update_fields=['playback_position', 'is_playing', 'state_updated_at', 'updated_at']
        )
        return room

    @database_sync_to_async
    def _join_participant(self, room):
        role = RoomParticipant.ROLE_HOST if self.is_host else RoomParticipant.ROLE_VIEWER
        if self.user.is_authenticated:
            participant, _ = RoomParticipant.objects.get_or_create(
                room=room, user=self.user, defaults={'role': role}
            )
            participant.role = role
            participant.is_online = True
            participant.left_at = None
            participant.save(update_fields=['role', 'is_online', 'left_at', 'updated_at'])
        else:
            participant = RoomParticipant.objects.create(
                room=room, role=role, is_online=True, guest_label='Гость'
            )
        self.participant_id = participant.pk

    @database_sync_to_async
    def _leave_participant(self):
        if self.participant_id is None:
            return
        RoomParticipant.objects.filter(pk=self.participant_id).update(
            is_online=False, left_at=timezone.now()
        )

    @database_sync_to_async
    def _participants_payload(self):
        online = (
            RoomParticipant.objects
            .filter(room_id=self.room_id, is_online=True)
            .select_related('user')
        )
        names = [p.display_name for p in online]
        return {'type': 'room.participants', 'count': len(names), 'viewers': names}
