"""Сервисный слой аккаунтов: выпуск и доставка одноразовых кодов.

Вынесено из views/serializers, чтобы логика «выпустить код и отправить письмо»
имела одну точку определения (SOLID — единая ответственность).
"""

from django.conf import settings
from django.core.mail import send_mail
from rest_framework_simplejwt.tokens import RefreshToken

from .models import LoginCode


def send_login_code(user, raw_code, purpose):
    """Отправляет письмо с одноразовым кодом."""
    action = 'регистрации' if purpose == LoginCode.PURPOSE_REGISTER else 'входа'
    subject = 'Код для входа в blxck.hub'
    body = (
        f'Здравствуйте, {user.first_name}!\n\n'
        f'Ваш код для {action} в blxck.hub: {raw_code}\n'
        f'Код действителен 10 минут.\n\n'
        f'Если вы не запрашивали код, просто проигнорируйте это письмо.'
    )
    send_mail(subject, body, settings.DEFAULT_FROM_EMAIL, [user.email])


def issue_and_send_code(user, purpose):
    """Выпускает одноразовый код и отправляет его пользователю на почту."""
    login_code, raw_code = LoginCode.issue(user, purpose)
    send_login_code(user, raw_code, purpose)
    return login_code


def issue_jwt_pair(user):
    """Формирует пару JWT-токенов (access + refresh) для пользователя."""
    refresh = RefreshToken.for_user(user)
    return {'access': str(refresh.access_token), 'refresh': str(refresh)}
