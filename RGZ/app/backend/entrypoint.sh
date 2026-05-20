#!/usr/bin/env sh
# Точка входа контейнера бэкенда: миграции, сбор статики, запуск ASGI-сервера.
set -e

python manage.py migrate --noinput
python manage.py collectstatic --noinput

exec daphne -b 0.0.0.0 -p 8000 config.asgi:application
