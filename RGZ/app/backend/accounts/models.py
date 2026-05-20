"""Модели аккаунтов: пользователь без пароля и одноразовые коды входа."""

import secrets
from datetime import timedelta

from django.contrib.auth.hashers import check_password, make_password
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.db import models
from django.utils import timezone

from common.models import TimeStampedModel

# Срок жизни одноразового кода и предел неверных попыток ввода.
CODE_TTL = timedelta(minutes=10)
MAX_CODE_ATTEMPTS = 5


class UserManager(BaseUserManager):
    """Менеджер пользователей: вход по e-mail, паролей нет."""

    use_in_migrations = True

    def create_user(self, email, first_name='', last_name='', **extra):
        if not email:
            raise ValueError('E-mail обязателен')
        email = self.normalize_email(email)
        user = self.model(email=email, first_name=first_name, last_name=last_name, **extra)
        user.set_unusable_password()  # вход только по одноразовому коду
        user.save(using=self._db)
        return user

    def create_superuser(self, email, first_name='', last_name='', password=None, **extra):
        extra.setdefault('is_staff', True)
        extra.setdefault('is_superuser', True)
        user = self.create_user(email, first_name, last_name, **extra)
        # Суперпользователю (для админки) пароль нужен.
        if password:
            user.set_password(password)
            user.save(using=self._db)
        return user


class User(AbstractBaseUser, PermissionsMixin):
    """Пользователь платформы. Идентификация по e-mail, авторизация — по коду."""

    email = models.EmailField('e-mail', unique=True)
    first_name = models.CharField('имя', max_length=150)
    last_name = models.CharField('фамилия', max_length=150)
    # «Имя в чате» из дизайна — отдельное редактируемое имя для комнат.
    chat_display_name = models.CharField('имя в чате', max_length=150, blank=True)
    is_active = models.BooleanField('активен', default=True)
    is_staff = models.BooleanField('доступ в админку', default=False)
    date_joined = models.DateTimeField('дата регистрации', default=timezone.now)

    objects = UserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['first_name', 'last_name']

    class Meta:
        verbose_name = 'пользователь'
        verbose_name_plural = 'пользователи'
        ordering = ('-date_joined',)

    def __str__(self):
        return self.email

    @property
    def display_name(self):
        """Имя для показа в чате: явное «имя в чате» или имя по умолчанию."""
        return self.chat_display_name or self.first_name or self.email.split('@')[0]


class LoginCode(TimeStampedModel):
    """Одноразовый код для регистрации или входа. Хранится в виде хеша."""

    PURPOSE_REGISTER = 'register'
    PURPOSE_LOGIN = 'login'
    PURPOSE_CHOICES = (
        (PURPOSE_REGISTER, 'Регистрация'),
        (PURPOSE_LOGIN, 'Вход'),
    )

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='login_codes')
    code_hash = models.CharField('хеш кода', max_length=256)
    purpose = models.CharField('назначение', max_length=16, choices=PURPOSE_CHOICES)
    expires_at = models.DateTimeField('действителен до')
    consumed_at = models.DateTimeField('использован', null=True, blank=True)
    attempts = models.PositiveSmallIntegerField('неверных попыток', default=0)

    class Meta:
        verbose_name = 'код входа'
        verbose_name_plural = 'коды входа'
        ordering = ('-created_at',)

    def __str__(self):
        return f'{self.user.email} · {self.get_purpose_display()}'

    @classmethod
    def issue(cls, user, purpose):
        """Создаёт новый код, гасит прежние неиспользованные коды того же назначения."""
        cls.objects.filter(user=user, purpose=purpose, consumed_at__isnull=True).update(
            consumed_at=timezone.now()
        )
        raw_code = f'{secrets.randbelow(1_000_000):06d}'
        instance = cls.objects.create(
            user=user,
            code_hash=make_password(raw_code),
            purpose=purpose,
            expires_at=timezone.now() + CODE_TTL,
        )
        return instance, raw_code

    @property
    def is_expired(self):
        return timezone.now() >= self.expires_at

    @property
    def is_usable(self):
        return self.consumed_at is None and not self.is_expired and self.attempts < MAX_CODE_ATTEMPTS

    def verify(self, raw_code):
        """Проверяет введённый код. Возвращает True при успехе, иначе пишет попытку."""
        if not self.is_usable:
            return False
        if check_password(raw_code, self.code_hash):
            self.consumed_at = timezone.now()
            self.save(update_fields=['consumed_at', 'updated_at'])
            return True
        self.attempts += 1
        self.save(update_fields=['attempts', 'updated_at'])
        return False
