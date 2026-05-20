"""Эндпоинты комнат совместного просмотра.

Живое управление плеером и чат идут по WebSocket (rooms.consumers); REST здесь
отвечает за создание комнаты, чтение её состояния и список своих комнат.
"""

from rest_framework import mixins, viewsets
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response

from .models import WatchRoom
from .serializers import RoomCreateSerializer, WatchRoomSerializer


class WatchRoomViewSet(
    mixins.CreateModelMixin,
    mixins.RetrieveModelMixin,
    mixins.ListModelMixin,
    viewsets.GenericViewSet,
):
    """Создание комнаты, чтение по ссылке и список комнат пользователя."""

    def get_permissions(self):
        # Открыть комнату по ссылке может любой (в т.ч. гость); создавать и
        # просматривать список своих комнат — только авторизованные.
        if self.action == 'retrieve':
            return [AllowAny()]
        return [IsAuthenticated()]

    def get_serializer_class(self):
        return RoomCreateSerializer if self.action == 'create' else WatchRoomSerializer

    def get_queryset(self):
        qs = WatchRoom.objects.select_related('video', 'video__owner', 'host')
        if self.action == 'list':
            return qs.filter(host=self.request.user)
        return qs

    def create(self, request, *args, **kwargs):
        serializer = RoomCreateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        room = serializer.save(host=request.user)
        data = WatchRoomSerializer(room, context=self.get_serializer_context()).data
        return Response(data, status=201)
