"""Сериализаторы приложения rooms."""

from django.utils import timezone
from rest_framework import serializers

from videos.serializers import VideoSerializer

from .models import WatchRoom
from .sync import effective_position


class WatchRoomSerializer(serializers.ModelSerializer):
    """Полное представление комнаты с вложенным видео и текущим состоянием."""

    video = VideoSerializer(read_only=True)
    host = serializers.SerializerMethodField()
    is_host = serializers.SerializerMethodField()
    playback_position = serializers.SerializerMethodField()
    participants_count = serializers.SerializerMethodField()

    class Meta:
        model = WatchRoom
        fields = (
            'id', 'title', 'video', 'host', 'is_host', 'is_active',
            'is_playing', 'playback_position', 'participants_count', 'created_at',
        )

    def get_host(self, obj):
        return {'id': obj.host_id, 'display_name': obj.host.display_name}

    def get_is_host(self, obj):
        user = self.context['request'].user
        return user.is_authenticated and user.id == obj.host_id

    def get_playback_position(self, obj):
        position = effective_position(
            obj.is_playing, obj.playback_position, obj.state_updated_at, timezone.now()
        )
        return round(position, 3)

    def get_participants_count(self, obj):
        return obj.participants.filter(is_online=True).count()


class RoomCreateSerializer(serializers.ModelSerializer):
    """Создание комнаты под выбранное видео."""

    class Meta:
        model = WatchRoom
        fields = ('id', 'video', 'title')
        read_only_fields = ('id',)
