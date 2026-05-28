# REST API

Базовый префикс — `/api/`. Аутентификация по JWT (Bearer-токен в заголовке
`Authorization`). Регистрация и вход возвращают пару access + refresh.

## Аутентификация

### `POST /api/auth/register/`

Регистрация пользователя.

Тело:

```json
{
  "username": "alice",
  "password": "verysecret123",
  "display_name": "Алиса"
}
```

Ответ `201`:

```json
{
  "access": "<JWT>",
  "refresh": "<JWT>",
  "user": {
    "id": 1,
    "username": "alice",
    "display_name": "Алиса",
    "is_guest": false
  }
}
```

### `POST /api/auth/login/`

Вход. Тело: `{"username": "...", "password": "..."}`. Ответ — как у регистрации.

### `POST /api/auth/guest/`

Создаёт гостевой аккаунт без пароля. Гости автоматически удаляются после 24
часов простоя вместе со своими видео.

Тело пустое. Ответ `201`:

```json
{
  "access": "<JWT>",
  "refresh": "<JWT>",
  "user": {
    "id": 42,
    "username": "guest-9f3a",
    "display_name": "Гость",
    "is_guest": true
  }
}
```

### `POST /api/auth/refresh/`

Обновление access-токена. Тело: `{"refresh": "<JWT>"}`. Ответ: `{"access": "<JWT>"}`.

### `POST /api/auth/logout/`

Инвалидирует переданный refresh-токен. Тело: `{"refresh": "<JWT>"}`.

### `POST /api/auth/logout-all/`

Инвалидирует все refresh-токены пользователя (выход со всех устройств).
Требует Bearer-токен. Тело пустое.

### `GET /api/auth/me/`

Профиль текущего пользователя.

### `PATCH /api/auth/me/`

Меняет видимое имя.

Тело: `{"display_name": "Алиса Иванова"}`.

## Видео

### `GET /api/videos/`

Лента видео (постранично, 12 на страницу).

Параметры: `?page=1`, `?owner=<id>` (только видео конкретного пользователя),
`?mine=true` (требует авторизации — только свои).

Ответ:

```json
{
  "count": 24,
  "next": "/api/videos/?page=2",
  "previous": null,
  "results": [
    {
      "id": "9c2b...",
      "title": "Прогулка по городу",
      "description": "...",
      "owner": {"id": 1, "display_name": "Алиса"},
      "stream_url": "/media/videos/abc.mp4",
      "thumbnail_url": "/media/thumbs/abc.jpg",
      "duration": 312.5,
      "views_count": 17,
      "is_public": true,
      "created_at": "2026-05-28T12:34:56Z"
    }
  ]
}
```

### `GET /api/videos/<uuid>/`

Получает одно видео по идентификатору. Инкрементирует счётчик просмотров.

### `POST /api/videos/`

Загружает новое видео. Тело — `multipart/form-data`:

| Поле          | Тип    | Обязательное | Описание                  |
|---------------|--------|--------------|---------------------------|
| `title`       | string | да           | Название                  |
| `description` | string | нет          | Описание                  |
| `file`        | file   | да           | Видеофайл (mp4)           |
| `thumbnail`   | file   | нет          | Кадр-превью (jpg/png)     |
| `is_public`   | bool   | нет          | По умолчанию `true`       |

Ограничение размера — `MAX_UPLOAD_SIZE` (по умолчанию 200 МБ).

### `PATCH /api/videos/<uuid>/`

Меняет метаданные собственного видео: `title`, `description`, `is_public`,
`thumbnail`. Только владелец.

### `DELETE /api/videos/<uuid>/`

Удаляет своё видео и связанный файл с диска. Только владелец.

### `GET /api/videos/<uuid>/stream/`

Прямая отдача видеофайла с поддержкой HTTP Range (для перемотки в плеере).
Возвращает `206 Partial Content`. В продакшене эту функцию обычно перекрывает
Caddy/nginx (отдача `/media/*` со статики).

## Служебное

### `GET /api/health/`

Проверка живости сервиса. Ответ: `{"status": "ok"}`.

## Ошибки

Все ошибки возвращаются в едином формате:

```json
{"detail": "Текст ошибки"}
```

Коды:

- `400` — некорректные параметры (детали в `detail` или per-field словаре).
- `401` — токен отсутствует, истёк или недействителен.
- `403` — нет прав на действие (чужой объект).
- `404` — объект не найден.
- `413` — превышен лимит размера загружаемого файла.
