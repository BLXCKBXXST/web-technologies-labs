"""Тесты авторизации без пароля: регистрация, выпуск кода, выдача JWT."""

from datetime import timedelta
from unittest.mock import patch

import pytest
from django.utils import timezone
from rest_framework.test import APIClient

from accounts.models import LoginCode, User

pytestmark = pytest.mark.django_db


@pytest.fixture
def api():
    return APIClient()


def register(api, email='ivan@example.com'):
    """Регистрирует пользователя, перехватывая отправку письма с кодом."""
    with patch('accounts.services.send_login_code') as mock_send:
        resp = api.post(
            '/api/auth/register/',
            {'email': email, 'first_name': 'Иван', 'last_name': 'Петров'},
            format='json',
        )
    return resp, mock_send


def test_register_creates_user_and_issues_code(api):
    resp, mock_send = register(api)
    assert resp.status_code == 202
    assert User.objects.filter(email='ivan@example.com').exists()
    user, raw_code, purpose = mock_send.call_args[0]
    assert len(raw_code) == 6 and raw_code.isdigit()
    assert purpose == LoginCode.PURPOSE_REGISTER


def test_register_duplicate_email_rejected(api):
    register(api)
    resp, _ = register(api)
    assert resp.status_code == 400
    assert 'email' in resp.json()


def test_verify_with_correct_code_returns_jwt(api):
    _, mock_send = register(api)
    raw_code = mock_send.call_args[0][1]
    resp = api.post(
        '/api/auth/verify/',
        {'email': 'ivan@example.com', 'code': raw_code},
        format='json',
    )
    assert resp.status_code == 200
    body = resp.json()
    assert 'access' in body and 'refresh' in body
    assert body['user']['email'] == 'ivan@example.com'


def test_verify_with_wrong_code_rejected(api):
    register(api)
    resp = api.post(
        '/api/auth/verify/',
        {'email': 'ivan@example.com', 'code': '000000'},
        format='json',
    )
    assert resp.status_code == 400


def test_verify_with_expired_code_rejected(api):
    _, mock_send = register(api)
    raw_code = mock_send.call_args[0][1]
    code = LoginCode.objects.latest('created_at')
    code.expires_at = timezone.now() - timedelta(minutes=1)
    code.save()
    resp = api.post(
        '/api/auth/verify/',
        {'email': 'ivan@example.com', 'code': raw_code},
        format='json',
    )
    assert resp.status_code == 400


def test_verify_with_consumed_code_rejected(api):
    _, mock_send = register(api)
    raw_code = mock_send.call_args[0][1]
    # Первая проверка кода успешна и гасит код.
    api.post(
        '/api/auth/verify/',
        {'email': 'ivan@example.com', 'code': raw_code},
        format='json',
    )
    # Повторное использование того же кода невозможно.
    resp = api.post(
        '/api/auth/verify/',
        {'email': 'ivan@example.com', 'code': raw_code},
        format='json',
    )
    assert resp.status_code == 400


def test_code_locks_after_five_attempts(api):
    _, mock_send = register(api)
    raw_code = mock_send.call_args[0][1]
    for _ in range(5):
        api.post(
            '/api/auth/verify/',
            {'email': 'ivan@example.com', 'code': '111111'},
            format='json',
        )
    # После пяти неверных попыток даже верный код не принимается.
    resp = api.post(
        '/api/auth/verify/',
        {'email': 'ivan@example.com', 'code': raw_code},
        format='json',
    )
    assert resp.status_code == 400
    assert LoginCode.objects.latest('created_at').attempts >= 5


def test_request_code_for_unknown_email_still_ok(api):
    # Ответ не раскрывает, зарегистрирован ли e-mail.
    resp = api.post(
        '/api/auth/request-code/',
        {'email': 'nobody@example.com'},
        format='json',
    )
    assert resp.status_code == 200


def test_request_code_for_known_email_sends_login_code(api):
    register(api)
    with patch('accounts.services.send_login_code') as mock_send:
        resp = api.post(
            '/api/auth/request-code/',
            {'email': 'ivan@example.com'},
            format='json',
        )
    assert resp.status_code == 200
    assert mock_send.call_args[0][2] == LoginCode.PURPOSE_LOGIN


def test_me_requires_authentication(api):
    assert api.get('/api/auth/me/').status_code == 401


def test_me_returns_and_updates_profile(api):
    _, mock_send = register(api)
    raw_code = mock_send.call_args[0][1]
    tokens = api.post(
        '/api/auth/verify/',
        {'email': 'ivan@example.com', 'code': raw_code},
        format='json',
    ).json()
    api.credentials(HTTP_AUTHORIZATION='Bearer ' + tokens['access'])

    resp = api.get('/api/auth/me/')
    assert resp.status_code == 200
    assert resp.json()['email'] == 'ivan@example.com'

    updated = api.patch('/api/auth/me/', {'chat_display_name': 'Ванёк'}, format='json')
    assert updated.status_code == 200
    assert updated.json()['chat_display_name'] == 'Ванёк'
