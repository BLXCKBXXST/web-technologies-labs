"""Базовые абстрактные модели — точка повторного использования (DRY)."""

import uuid

from django.db import models


class TimeStampedModel(models.Model):
    """Добавляет отметки создания и изменения записи."""

    created_at = models.DateTimeField('создано', auto_now_add=True)
    updated_at = models.DateTimeField('изменено', auto_now=True)

    class Meta:
        abstract = True
        ordering = ('-created_at',)


class UUIDModel(models.Model):
    """Первичный ключ — UUID (непредсказуемые ссылки на видео)."""

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)

    class Meta:
        abstract = True
