"""Настройки источников каталога.

Одна запись на источник (kinogo/zona). Меняется через `/admin/` без редеплоя:
зеркало упало — берёшь актуальное у @kinogobiz_bot, открываешь админку и
правишь поле base_url. Парсер подхватит изменение в течение 30 секунд.
"""

from django.db import models


class SourceConfig(models.Model):
    """Конфигурация одного источника каталога."""

    SOURCE_KINOGO = 'kinogo'
    SOURCE_ZONA = 'zona'
    SOURCE_CHOICES = (
        (SOURCE_KINOGO, 'Kinogo'),
        (SOURCE_ZONA, 'Zona'),
    )

    source_id = models.CharField(
        'идентификатор источника',
        max_length=16,
        choices=SOURCE_CHOICES,
        unique=True,
    )
    base_url = models.URLField(
        'базовый URL зеркала',
        max_length=255,
        help_text='Например, https://kinogo.la или личное зеркало от @kinogobiz_bot.',
    )
    username = models.CharField(
        'логин (для входа на источнике)',
        max_length=120,
        blank=True,
        help_text='Если задан, парсер войдёт под этой учёткой — это убирает рекламу в плеере.',
    )
    password = models.CharField(
        'пароль',
        max_length=255,
        blank=True,
    )
    is_active = models.BooleanField('включён', default=True)
    notes = models.TextField('заметки', blank=True)

    created_at = models.DateTimeField('создано', auto_now_add=True)
    updated_at = models.DateTimeField('изменено', auto_now=True)

    class Meta:
        verbose_name = 'источник каталога'
        verbose_name_plural = 'источники каталога'
        ordering = ('source_id',)

    def __str__(self):
        return f'{self.get_source_id_display()} → {self.base_url}'
