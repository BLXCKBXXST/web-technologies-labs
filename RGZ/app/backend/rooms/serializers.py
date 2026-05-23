"""Сериализаторы приложения rooms."""

from django.utils import timezone
from rest_framework import serializers

from videos.serializers import VideoSerializer

from .external_video import resolve_external
from .models import WatchRoom
from .sync import effective_position

try:
    from catalog.errors import CatalogError
    from catalog.parsers import get_parser
except ImportError:  # pragma: no cover — каталог опционален
    get_parser = None
    CatalogError = None


class WatchRoomSerializer(serializers.ModelSerializer):
    """Полное представление комнаты с вложенным видео и текущим состоянием."""

    video = VideoSerializer(read_only=True)
    host = serializers.SerializerMethodField()
    is_host = serializers.SerializerMethodField()
    playback_position = serializers.SerializerMethodField()
    participants_count = serializers.SerializerMethodField()
    is_external = serializers.SerializerMethodField()
    stream_url = serializers.SerializerMethodField()
    display_title = serializers.SerializerMethodField()

    class Meta:
        model = WatchRoom
        fields = (
            'id', 'title', 'display_title', 'video', 'host', 'is_host', 'is_active',
            'is_playing', 'playback_position', 'participants_count', 'created_at',
            'is_external', 'external_url', 'external_title',
            'external_thumbnail_url', 'external_duration', 'stream_url',
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

    def get_is_external(self, obj):
        return obj.is_external

    def get_display_title(self, obj):
        return obj.display_title

    def get_stream_url(self, obj):
        # У внешнего источника прямой URL уже сохранён в комнате; у загруженного
        # видео отдаём наш HTTP-эндпоинт стриминга.
        if obj.is_external:
            return obj.stream_url
        if obj.video_id:
            return f'/api/videos/{obj.video_id}/stream/'
        return ''


class RoomCreateSerializer(serializers.ModelSerializer):
    """Создание комнаты под загруженное видео, внешний URL или тайтл из каталога."""

    external_url = serializers.CharField(required=False, allow_blank=True, max_length=2048)
    catalog_source = serializers.CharField(required=False, allow_blank=True, max_length=32)
    catalog_external_id = serializers.CharField(required=False, allow_blank=True, max_length=128)
    catalog_season = serializers.IntegerField(required=False, allow_null=True)
    catalog_episode = serializers.IntegerField(required=False, allow_null=True)

    class Meta:
        model = WatchRoom
        fields = (
            'id', 'video', 'external_url', 'title',
            'catalog_source', 'catalog_external_id', 'catalog_season', 'catalog_episode',
        )
        read_only_fields = ('id',)
        extra_kwargs = {'video': {'required': False, 'allow_null': True}}

    def validate(self, attrs):
        video = attrs.get('video')
        external_url = (attrs.get('external_url') or '').strip()
        catalog_source = (attrs.get('catalog_source') or '').strip()
        catalog_id = (attrs.get('catalog_external_id') or '').strip()
        sources = [bool(video), bool(external_url), bool(catalog_source and catalog_id)]
        if sum(sources) == 0:
            raise serializers.ValidationError(
                'Нужно указать либо загруженное видео (video), либо внешний URL '
                '(external_url), либо тайтл из каталога (catalog_source + catalog_external_id).'
            )
        if sum(sources) > 1:
            raise serializers.ValidationError(
                'Нельзя одновременно задавать несколько источников: video / external_url / catalog.'
            )
        attrs['external_url'] = external_url
        attrs['catalog_source'] = catalog_source
        attrs['catalog_external_id'] = catalog_id
        return attrs

    def create(self, validated_data):
        external_url = validated_data.pop('external_url', '')
        catalog_source = validated_data.pop('catalog_source', '')
        catalog_id = validated_data.pop('catalog_external_id', '')
        catalog_season = validated_data.pop('catalog_season', None)
        catalog_episode = validated_data.pop('catalog_episode', None)

        if external_url:
            info = resolve_external(external_url)
            validated_data.update({
                'external_url': external_url,
                'external_kind': info['kind'],
                'stream_url': info['url'],
                'external_title': info['title'],
                'external_duration': info['duration'],
                'external_thumbnail_url': info['thumbnail'],
                'external_resolved_at': timezone.now(),
            })
        elif catalog_source and catalog_id and get_parser is not None:
            try:
                parser = get_parser(catalog_source)
                details = parser.title(catalog_id)
                stream = parser.stream(catalog_id, season=catalog_season, episode=catalog_episode)
            except CatalogError as exc:  # type: ignore[misc]
                raise serializers.ValidationError({'catalog_external_id': str(exc)}) from exc
            validated_data.update({
                'external_url': details.url or '',
                'external_kind': f'catalog:{catalog_source}',
                'stream_url': stream.url,
                'external_title': stream.title or details.title,
                'external_duration': stream.duration or details.duration_minutes,
                'external_thumbnail_url': stream.thumbnail or details.poster,
                'external_resolved_at': timezone.now(),
            })
        return super().create(validated_data)
