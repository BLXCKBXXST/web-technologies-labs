# API blxck.hub

Справочник REST- и WebSocket-API платформы.

- Базовый префикс REST — `/api/`.
- Формат тела запросов и ответов — JSON (загрузка видео — `multipart/form-data`).
- Авторизация — заголовок `Authorization: Bearer <access-токен>`.
- Примеры `curl` приведены для локального запуска (`http://localhost:8000`).

---

## Аутентификация

Платформа не использует пароли: вход выполняется по одноразовому коду,
отправленному на e-mail. После проверки кода выдаётся пара JWT-токенов.

### POST /api/auth/register/ — регистрация

Создаёт пользователя и отправляет код подтверждения на e-mail.

Тело: `email`, `first_name`, `last_name`.

```bash
curl -X POST http://localhost:8000/api/auth/register/ \
  -H 'Content-Type: application/json' \
  -d '{"email":"ivan@example.com","first_name":"Иван","last_name":"Петров"}'
```

Ответ `202 Accepted`:

```json
{ "detail": "Код отправлен на ваш e-mail." }
```

### POST /api/auth/request-code/ — запрос кода для входа

Отправляет одноразовый код уже зарегистрированному пользователю. Ответ всегда
`200` и не раскрывает, существует ли такой e-mail.

```bash
curl -X POST http://localhost:8000/api/auth/request-code/ \
  -H 'Content-Type: application/json' \
  -d '{"email":"ivan@example.com"}'
```

```json
{ "detail": "Если e-mail зарегистрирован, код отправлен." }
```

### POST /api/auth/verify/ — проверка кода, выдача токенов

Тело: `email`, `code` (6 цифр). При успехе возвращает JWT-пару и профиль.

```bash
curl -X POST http://localhost:8000/api/auth/verify/ \
  -H 'Content-Type: application/json' \
  -d '{"email":"ivan@example.com","code":"480913"}'
```

Ответ `200`:

```json
{
  "access": "eyJhbGciOiJIUzI1NiI...",
  "refresh": "eyJhbGciOiJIUzI1NiI...",
  "user": {
    "id": 1, "email": "ivan@example.com",
    "first_name": "Иван", "last_name": "Петров",
    "chat_display_name": "", "display_name": "Иван"
  }
}
```

Ошибки: `400` — неверный, просроченный или использованный код.

### POST /api/auth/refresh/ — обновление access-токена

```bash
curl -X POST http://localhost:8000/api/auth/refresh/ \
  -H 'Content-Type: application/json' \
  -d '{"refresh":"eyJhbGciOiJIUzI1NiI..."}'
```

```json
{ "access": "eyJhbGciOiJIUzI1NiI..." }
```

### GET /api/auth/me/ — текущий профиль

Требует авторизации.

```bash
curl http://localhost:8000/api/auth/me/ -H "Authorization: Bearer $ACCESS"
```

### PATCH /api/auth/me/ — изменение профиля

Позволяет менять `first_name`, `last_name`, `chat_display_name` (имя в чате).

```bash
curl -X PATCH http://localhost:8000/api/auth/me/ \
  -H "Authorization: Bearer $ACCESS" -H 'Content-Type: application/json' \
  -d '{"chat_display_name":"Ванёк"}'
```

---

## Видео

### GET /api/videos/ — лента

Постраничный список опубликованных видео. Параметры: `page`, `page_size`.

```bash
curl http://localhost:8000/api/videos/
```

```json
{
  "count": 1, "next": null, "previous": null,
  "results": [
    {
      "id": "4f3c...", "title": "Лекция 1", "description": "Вводная",
      "owner": { "id": 1, "display_name": "Иван" },
      "duration_seconds": 612, "size_bytes": 18234567,
      "content_type": "video/mp4", "views_count": 42, "is_public": true,
      "created_at": "2026-05-20T10:00:00+07:00",
      "thumbnail_url": "/media/thumbnails/4f3c.../t.jpg",
      "stream_url": "/api/videos/4f3c.../stream/"
    }
  ]
}
```

### POST /api/videos/ — загрузка видео

Требует авторизации. `multipart/form-data`: `file`, `title`, `description`,
`thumbnail` (необязательно), `is_public` (`true`/`false`).

```bash
curl -X POST http://localhost:8000/api/videos/ \
  -H "Authorization: Bearer $ACCESS" \
  -F 'title=Лекция 1' -F 'description=Вводная' \
  -F 'file=@lecture.mp4;type=video/mp4' -F 'is_public=true'
```

Ответ `201` — объект видео (как в ленте).

### GET /api/videos/{id}/ — карточка видео

Возвращает видео и увеличивает счётчик просмотров.

### GET /api/videos/{id}/stream/ — потоковая отдача

Отдаёт файл с поддержкой заголовка `Range` (ответ `206 Partial Content`).
Используется тегом `<video>` для воспроизведения и перемотки.

```bash
curl -I -H 'Range: bytes=0-1023' http://localhost:8000/api/videos/4f3c.../stream/
# HTTP/1.1 206 Partial Content
# Content-Range: bytes 0-1023/18234567
```

### GET /api/videos/mine/ — мои видео

Требует авторизации. Постраничный список видео текущего пользователя.

### PATCH /api/videos/{id}/ — изменение метаданных

Только владелец. Поля: `title`, `description`, `is_public`.

### DELETE /api/videos/{id}/ — удаление

Только владелец. Ответ `204`.

---

## Комнаты совместного просмотра

### POST /api/rooms/ — создать комнату

Требует авторизации. Тело: `video` (id), `title` (необязательно).
Создатель становится ведущим.

```bash
curl -X POST http://localhost:8000/api/rooms/ \
  -H "Authorization: Bearer $ACCESS" -H 'Content-Type: application/json' \
  -d '{"video":"4f3c...","title":"Смотрим вместе"}'
```

Ответ `201`:

```json
{
  "id": "a91d...", "title": "Смотрим вместе",
  "video": { "id": "4f3c...", "title": "Лекция 1", "stream_url": "..." },
  "host": { "id": 1, "display_name": "Иван" },
  "is_host": true, "is_active": true,
  "is_playing": false, "playback_position": 0.0,
  "participants_count": 0, "created_at": "2026-05-20T10:05:00+07:00"
}
```

### GET /api/rooms/{id}/ — состояние комнаты

Доступно всем по ссылке (в т.ч. гостям). Поле `playback_position` — текущая
позиция с поправкой на прошедшее время, `is_host` — является ли запрашивающий
ведущим.

### GET /api/rooms/ — мои комнаты

Требует авторизации. Список комнат, где пользователь — ведущий.

### GET /api/rooms/{id}/messages/ — история чата

Сообщения комнаты по возрастанию времени (для загрузки при входе).

### GET /api/rooms/{id}/questions/ — вопросы комнаты

Вопросы со вложенными ответами.

---

## WebSocket — комната реального времени

Адрес: `ws(s)://<хост>/ws/rooms/{room_id}/?token=<access>`

Браузерный WebSocket не передаёт заголовки авторизации, поэтому access-токен
передаётся query-параметром `token`. Без токена соединение устанавливается как
гостевое (только просмотр синхронизации, без отправки в чат).

Все сообщения — JSON с полем `type`.

### Клиент → сервер

| type | Поля | Кто отправляет |
|------|------|----------------|
| `player.play` | `position`, `is_playing` | только ведущий |
| `player.pause` | `position`, `is_playing` | только ведущий |
| `player.seek` | `position`, `is_playing` | только ведущий |
| `player.sync_request` | — | любой |
| `chat.message` | `text` | авторизованный |
| `chat.like` | `message_id` | авторизованный |
| `qa.question` | `text` | авторизованный |
| `qa.answer` | `question_id`, `text` | авторизованный |
| `qa.upvote` | `question_id` | авторизованный |

### Сервер → клиент

| type | Поля |
|------|------|
| `room.state` | `is_playing`, `position`, `server_time` |
| `room.participants` | `count`, `viewers` (список имён) |
| `chat.message` | `message` (`id`, `display_name`, `text`, `likes_count`, `created_at`) |
| `chat.like` | `message_id`, `likes_count` |
| `qa.question` | `question` (`id`, `display_name`, `text`, `is_answered`, `upvotes_count`, `answers`) |
| `qa.answer` | `question_id`, `answer` |
| `qa.upvote` | `question_id`, `upvotes_count` |

### Алгоритм синхронизации

1. При подключении сервер отправляет `room.state` — текущее состояние плеера.
2. Действия ведущего (`player.*`) сервер сохраняет в БД и рассылает группе
   как `room.state` с серверным временем `server_time`.
3. Зритель применяет состояние к своему плееру и раз в ~3 секунды сверяет
   позицию: рассинхрон более 1 с — резкая перемотка, 0.3–1 с — плавная
   подстройка скоростью воспроизведения.
