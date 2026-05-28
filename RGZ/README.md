# Видеохостинг

Простой веб-видеохостинг: загрузка роликов, каталог, плеер, личный профиль.
Расчётно-графическая работа по дисциплине «Web-технологии» (СибГУТИ).

Пользователи регистрируются, загружают свои видео, смотрят их в общей ленте
и в одиночном плеере, ведут личный профиль с возможностью править данные о
себе и удалять собственные ролики.

## Стек технологий

| Слой           | Технологии                                                        |
|----------------|-------------------------------------------------------------------|
| Бэкенд         | Python, Django 5, Django REST Framework                           |
| Сервер         | Gunicorn (WSGI)                                                   |
| База данных    | PostgreSQL (на сервере), SQLite (локальная разработка)            |
| Авторизация    | JWT (djangorestframework-simplejwt), вход по имени и паролю       |
| Фронтенд       | React, React Router, Vite, axios                                  |
| Инфраструктура | Docker, docker-compose, Caddy (reverse proxy + TLS Let's Encrypt) |

## Архитектура

```
                  ┌──────────┐
    браузер ─────▶│  Caddy   │  HTTPS, TLS Let's Encrypt
                  └────┬─────┘
                       │
              ┌────────▼──────────┐
              │ videohost-frontend│  nginx: SPA, /media, /static,
              │   (React + nginx) │  проксирование /api на бэкенд
              └────────┬──────────┘
                       │
              ┌────────▼──────────┐
              │ videohost-backend │  REST /api/*
              │ (Django + DRF +   │
              │      Gunicorn)    │
              └────────┬──────────┘
                       │
              ┌────────▼──┐
              │ Postgres  │
              └───────────┘
```

Подробное описание REST API — в [API.md](API.md).

## Возможности

- Регистрация и вход по имени пользователя и паролю, JWT-сессии.
- Гостевой вход одной кнопкой — гостевые аккаунты автоматически удаляются после
  24 часов простоя.
- Загрузка видео (mp4), лента, страница одиночного просмотра, потоковая отдача
  с поддержкой HTTP Range (перемотка по таймлайну).
- Личный профиль: видимое имя, аватар (первая буква имени), список своих
  загрузок с правкой и удалением.

## Запуск локально (для разработки)

```bash
# Бэкенд
cd app/backend
python -m venv .venv
.venv/bin/pip install -r requirements.txt
.venv/bin/python manage.py migrate
.venv/bin/python manage.py runserver

# Фронтенд (в другом терминале)
cd app/frontend
npm install
npm run dev
```

Откройте http://localhost:5173.

## Запуск целиком в Docker (демо-стек)

```bash
docker compose up --build
```

Готовое приложение на http://localhost:8080.

## Развёртывание на сервере

`deploy.sh` подразумевает, что на сервере уже поднят Caddy-стек в
`/opt/stack/`. Скрипт идемпотентный, повторный запуск ничего не ломает.

```bash
./deploy.sh --install     # развернуть
./deploy.sh --uninstall   # снести
```

## Адаптация под себя

- **Название платформы** меняется одной строкой в [app/frontend/.env](app/frontend/.env.example):
  `VITE_APP_NAME=МойХостинг`. После пересборки фронта название появится в шапке,
  в заголовке вкладки и на экранах входа.
- **Цвета, типографика, скругления, отступы** в одном файле
  [app/frontend/src/styles/tokens.css](app/frontend/src/styles/tokens.css).
  Поменяете `--color-accent`, изменится во всём интерфейсе.
- **Логотип** заменяется в [app/frontend/src/components/Header.jsx](app/frontend/src/components/Header.jsx)
  и [app/frontend/src/components/auth/AuthLayout.jsx](app/frontend/src/components/auth/AuthLayout.jsx)
  (по умолчанию текстовый, можно подставить `<img>` или SVG).

## Тесты

```bash
# Бэкенд
cd app/backend && .venv/bin/python -m pytest

# Фронтенд
cd app/frontend && npm test
```
