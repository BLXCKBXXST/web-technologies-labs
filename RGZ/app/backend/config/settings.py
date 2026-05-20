"""
Настройки Django-проекта blxck.hub.

Конфигурация управляется переменными окружения (django-environ): локально без
переменных используются SQLite и in-memory channel layer, на сервере через .env
подключаются PostgreSQL и Redis. Один и тот же код работает в обоих режимах.
"""

from datetime import timedelta
from pathlib import Path

import environ

BASE_DIR = Path(__file__).resolve().parent.parent

# --- Чтение окружения --------------------------------------------------------
env = environ.Env(
    DJANGO_DEBUG=(bool, True),
    DJANGO_ALLOWED_HOSTS=(list, ['*']),
    CORS_ALLOWED_ORIGINS=(list, ['http://localhost:5173', 'http://127.0.0.1:5173']),
)
# .env читается, если присутствует рядом с manage.py (на сервере). Локально не обязателен.
_env_file = BASE_DIR / '.env'
if _env_file.exists():
    env.read_env(_env_file)

SECRET_KEY = env('DJANGO_SECRET_KEY', default='django-insecure-dev-key-not-for-production')
DEBUG = env('DJANGO_DEBUG')
ALLOWED_HOSTS = env('DJANGO_ALLOWED_HOSTS')

# --- Приложения --------------------------------------------------------------
INSTALLED_APPS = [
    'daphne',  # ASGI-сервер; должен идти до staticfiles, чтобы runserver работал по ASGI
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    # Сторонние
    'rest_framework',
    'corsheaders',
    'channels',
    # Приложения проекта
    'common',
    'accounts',
    'videos',
    'rooms',
    'chat',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'config.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'config.wsgi.application'
ASGI_APPLICATION = 'config.asgi.application'

# --- База данных -------------------------------------------------------------
# Локально (без DATABASE_URL) — SQLite. На сервере — PostgreSQL через DATABASE_URL.
DATABASES = {
    'default': env.db_url(
        'DATABASE_URL',
        default=f'sqlite:///{BASE_DIR / "db.sqlite3"}',
    ),
}

# --- Channels: слой обмена сообщениями ---------------------------------------
# Локально (без REDIS_URL) — in-memory (хватает для одного процесса daphne).
# На сервере — Redis, чтобы несколько процессов видели общие группы комнат.
REDIS_URL = env('REDIS_URL', default='')
if REDIS_URL:
    CHANNEL_LAYERS = {
        'default': {
            'BACKEND': 'channels_redis.core.RedisChannelLayer',
            'CONFIG': {'hosts': [REDIS_URL]},
        },
    }
else:
    CHANNEL_LAYERS = {
        'default': {'BACKEND': 'channels.layers.InMemoryChannelLayer'},
    }

# --- Аутентификация ----------------------------------------------------------
AUTH_USER_MODEL = 'accounts.User'

# Паролей у пользователей нет (вход по одноразовому коду), валидаторы не нужны.
AUTH_PASSWORD_VALIDATORS = []

# --- DRF и JWT ---------------------------------------------------------------
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticatedOrReadOnly',
    ),
    'DEFAULT_PAGINATION_CLASS': 'common.pagination.DefaultPagination',
    'PAGE_SIZE': 12,
}

SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(minutes=30),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=7),
    'AUTH_HEADER_TYPES': ('Bearer',),
}

# --- CORS --------------------------------------------------------------------
CORS_ALLOWED_ORIGINS = env('CORS_ALLOWED_ORIGINS')

# --- Почта (доставка одноразовых кодов) --------------------------------------
# Локально — вывод письма в консоль (код виден в логах backend).
# На сервере — SMTP (iRedMail) через переменные EMAIL_*.
EMAIL_BACKEND = env('EMAIL_BACKEND', default='django.core.mail.backends.console.EmailBackend')
EMAIL_HOST = env('EMAIL_HOST', default='')
EMAIL_PORT = env.int('EMAIL_PORT', default=587)
EMAIL_HOST_USER = env('EMAIL_HOST_USER', default='')
EMAIL_HOST_PASSWORD = env('EMAIL_HOST_PASSWORD', default='')
EMAIL_USE_TLS = env.bool('EMAIL_USE_TLS', default=True)
DEFAULT_FROM_EMAIL = env('DEFAULT_FROM_EMAIL', default='no-reply@blxck.hub')

# --- Интернационализация -----------------------------------------------------
LANGUAGE_CODE = 'ru-ru'
TIME_ZONE = 'Asia/Novosibirsk'
USE_I18N = True
USE_TZ = True

# --- Статика и медиа ---------------------------------------------------------
STATIC_URL = 'static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'
MEDIA_URL = 'media/'
MEDIA_ROOT = env('MEDIA_ROOT', default=str(BASE_DIR / 'media'))

# Лимит размера загружаемого видео (200 МБ).
MAX_UPLOAD_SIZE = env.int('MAX_UPLOAD_SIZE', default=200 * 1024 * 1024)
DATA_UPLOAD_MAX_MEMORY_SIZE = MAX_UPLOAD_SIZE
FILE_UPLOAD_MAX_MEMORY_SIZE = 5 * 1024 * 1024  # выше — во временный файл на диске

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
