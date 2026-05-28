#!/usr/bin/env bash
# deploy.sh — развёртывание и снос видеохостинга на собственном сервере
# за обратным прокси Caddy.
#
# Использование (запускать НА сервере):
#   ./deploy.sh --install     # развернуть
#   ./deploy.sh --uninstall   # снести
#
# Требует уже установленного Caddy-стека (контейнер caddy в общем
# /opt/stack/docker-compose.yml). Оба режима идемпотентны и могут быть
# запущены повторно.
set -euo pipefail

STACK_DIR="/opt/stack"
COMPOSE_FILE="${STACK_DIR}/docker-compose.yml"
CADDY_FILE="${STACK_DIR}/caddy/Caddyfile"
APP_DIR="${STACK_DIR}/videohost"
ENV_FILE="${APP_DIR}/.env"
USER_NAME="$(id -un)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
    cat <<EOF
Usage: $(basename "$0") --install | --uninstall

  --install     Развернуть видеохостинг: синхронизировать исходники в ${APP_DIR},
                добавить сервисы videohost-db/backend/frontend в общий
                docker-compose.yml, дописать поддомен в Caddyfile, поднять стек.

  --uninstall   Снести: остановить и удалить контейнеры, убрать сервисы
                из docker-compose.yml и блок поддомена из Caddyfile, удалить
                ${APP_DIR}.

Оба режима идемпотентны и могут быть запущены повторно.
EOF
}

prompt_default() {
    local msg="$1" def="$2" var="$3" ans
    read -r -p "${msg} [${def}]: " ans || true
    printf -v "${var}" '%s' "${ans:-$def}"
}

require_caddy_stack() {
    if [[ ! -f "${COMPOSE_FILE}" ]]; then
        echo "ОШИБКА: ${COMPOSE_FILE} не найден. Сначала разверните Caddy-стек." >&2
        exit 1
    fi
    if [[ ! -f "${CADDY_FILE}" ]]; then
        echo "ОШИБКА: ${CADDY_FILE} не найден. Сначала разверните Caddy-стек." >&2
        exit 1
    fi
}

reload_caddy() {
    echo "==> Перезагружаю Caddy..."
    if ( cd "${STACK_DIR}" && docker compose exec -T caddy caddy reload --config /etc/caddy/Caddyfile 2>/dev/null ); then
        echo "    Caddy перечитал конфиг без рестарта."
    else
        echo "    caddy reload не сработал — перезапускаю контейнер."
        ( cd "${STACK_DIR}" && docker compose restart caddy )
    fi
}

# Случайная строка из шестнадцатеричных символов (безопасна для URL и .env).
gen_secret() {
    openssl rand -hex 32
}

action_install() {
    require_caddy_stack

    prompt_default "Домен для видеохостинга" "videohost.example.com" DOMAIN

    echo "==> Бэкаплю docker-compose.yml и Caddyfile..."
    local stamp; stamp="$(date +%Y%m%d-%H%M%S)"
    cp -a "${COMPOSE_FILE}" "${COMPOSE_FILE}.bak.${stamp}"
    cp -a "${CADDY_FILE}"   "${CADDY_FILE}.bak.${stamp}"

    echo "==> Создаю каталоги ${APP_DIR}..."
    sudo -A mkdir -p "${APP_DIR}/data/pg" "${APP_DIR}/data/media" "${APP_DIR}/data/static"
    sudo -A chown -R "${USER_NAME}:${USER_NAME}" "${APP_DIR}"

    echo "==> Синхронизирую исходники: ${SCRIPT_DIR}/app -> ${APP_DIR}/app..."
    rsync -a --delete \
        --exclude='.git' --exclude='node_modules' --exclude='.venv' \
        --exclude='__pycache__' --exclude='*.pyc' --exclude='db.sqlite3' \
        --exclude='media' --exclude='staticfiles' --exclude='dist' --exclude='.env' \
        "${SCRIPT_DIR}/app/" "${APP_DIR}/app/"

    if [[ ! -f "${ENV_FILE}" ]]; then
        echo "==> Генерирую ${ENV_FILE}..."
        local db_pass; db_pass="$(gen_secret)"
        cat >"${ENV_FILE}" <<EOF
DJANGO_SECRET_KEY=$(gen_secret)
DJANGO_DEBUG=False
DJANGO_ALLOWED_HOSTS=${DOMAIN}
DATABASE_URL=postgres://videohost:${db_pass}@videohost-db:5432/videohost
POSTGRES_DB=videohost
POSTGRES_USER=videohost
POSTGRES_PASSWORD=${db_pass}
CORS_ALLOWED_ORIGINS=https://${DOMAIN}
CSRF_TRUSTED_ORIGINS=https://${DOMAIN}
EOF
    else
        echo "==> ${ENV_FILE} уже существует — оставляю без изменений."
    fi

    if grep -qE '^[[:space:]]+videohost-backend:[[:space:]]*$' "${COMPOSE_FILE}"; then
        echo "==> Сервисы видеохостинга уже описаны в ${COMPOSE_FILE} — пропускаю."
    else
        echo "==> Добавляю сервисы видеохостинга в ${COMPOSE_FILE}..."
        cat >>"${COMPOSE_FILE}" <<'EOF'

  videohost-db:
    image: postgres:16-alpine
    container_name: videohost-db
    restart: unless-stopped
    env_file: ./videohost/.env
    volumes:
      - ./videohost/data/pg:/var/lib/postgresql/data

  videohost-backend:
    build: ./videohost/app/backend
    container_name: videohost-backend
    restart: unless-stopped
    env_file: ./videohost/.env
    depends_on:
      - videohost-db
    volumes:
      - ./videohost/data/media:/app/media
      - ./videohost/data/static:/app/staticfiles

  videohost-frontend:
    build: ./videohost/app/frontend
    container_name: videohost-frontend
    restart: unless-stopped
    depends_on:
      - videohost-backend
    volumes:
      - ./videohost/data/media:/srv/media:ro
      - ./videohost/data/static:/srv/static:ro
EOF
    fi

    if grep -qF "${DOMAIN} {" "${CADDY_FILE}"; then
        echo "==> Блок ${DOMAIN} уже есть в ${CADDY_FILE} — пропускаю."
    else
        echo "==> Дописываю блок ${DOMAIN} в ${CADDY_FILE}..."
        cat >>"${CADDY_FILE}" <<EOF

${DOMAIN} {
    encode gzip
    reverse_proxy videohost-frontend:80
}
EOF
    fi

    echo "==> docker compose config (валидация)..."
    ( cd "${STACK_DIR}" && docker compose config >/dev/null )

    echo "==> docker compose up -d --build (сборка может занять пару минут)..."
    ( cd "${STACK_DIR}" && docker compose up -d --build \
        videohost-db videohost-backend videohost-frontend )

    reload_caddy

    cat <<EOF

================================================================================
Видеохостинг развёрнут.

Публичный URL:
  https://${DOMAIN}  -> videohost-frontend (nginx) -> videohost-backend (gunicorn)

Дальнейшие шаги:
  1. Убедитесь, что DNS A/CNAME ${DOMAIN} указывает на внешний IP сервера.
  2. Откройте https://${DOMAIN} — при первом запросе Caddy ~30 секунд выпускает
     TLS-сертификат Let's Encrypt.
  3. Вход — по имени пользователя и паролю; есть кнопка «войти как гостем».
     Гостевые аккаунты автоматически удаляются после 24 ч простоя.
  4. Логи: docker logs -f videohost-backend | videohost-frontend | caddy

Снести после демонстрации:
  ./deploy.sh --uninstall
================================================================================
EOF
}

action_uninstall() {
    require_caddy_stack

    prompt_default "Домен для удаления" "videohost.example.com" DOMAIN

    echo "==> Бэкаплю docker-compose.yml и Caddyfile..."
    local stamp; stamp="$(date +%Y%m%d-%H%M%S)"
    cp -a "${COMPOSE_FILE}" "${COMPOSE_FILE}.bak.${stamp}"
    cp -a "${CADDY_FILE}"   "${CADDY_FILE}.bak.${stamp}"

    echo "==> Останавливаю и удаляю контейнеры видеохостинга..."
    for svc in videohost-frontend videohost-backend videohost-db; do
        if ( cd "${STACK_DIR}" && docker compose ps --services 2>/dev/null | grep -qx "${svc}" ); then
            ( cd "${STACK_DIR}" && docker compose stop "${svc}" && docker compose rm -f "${svc}" )
        fi
    done

    if grep -qE '^[[:space:]]+videohost-db:[[:space:]]*$' "${COMPOSE_FILE}"; then
        echo "==> Удаляю сервисы видеохостинга из ${COMPOSE_FILE}..."
        # Удаляем блок от строки "  videohost-db:" до следующего НЕ-videohost
        # сервиса (две ведущих пробела + слово) либо до конца файла.
        awk '
            BEGIN { skip = 0 }
            /^[[:space:]]+videohost-db:[[:space:]]*$/ { skip = 1; next }
            skip && /^[[:space:]]{2}[A-Za-z0-9_-]+:[[:space:]]*$/ && $0 !~ /videohost-/ { skip = 0 }
            skip && /^[A-Za-z]/ { skip = 0 }
            skip == 0 { print }
        ' "${COMPOSE_FILE}" > "${COMPOSE_FILE}.tmp"
        mv "${COMPOSE_FILE}.tmp" "${COMPOSE_FILE}"
    else
        echo "==> Сервисы видеохостинга отсутствуют в ${COMPOSE_FILE} — пропускаю."
    fi

    if grep -qF "${DOMAIN} {" "${CADDY_FILE}"; then
        echo "==> Удаляю блок ${DOMAIN} из ${CADDY_FILE}..."
        awk -v dom="${DOMAIN}" '
            BEGIN { skip = 0 }
            $0 ~ "^"dom" \\{$" { skip = 1; next }
            skip && /^\}[[:space:]]*$/ { skip = 0; next }
            skip == 0 { print }
        ' "${CADDY_FILE}" > "${CADDY_FILE}.tmp"
        mv "${CADDY_FILE}.tmp" "${CADDY_FILE}"
    else
        echo "==> Блок ${DOMAIN} отсутствует в ${CADDY_FILE} — пропускаю."
    fi

    if [[ -d "${APP_DIR}" ]]; then
        echo "==> Удаляю каталог ${APP_DIR}..."
        sudo -A rm -rf "${APP_DIR}"
    fi

    echo "==> docker compose config (валидация)..."
    ( cd "${STACK_DIR}" && docker compose config >/dev/null )

    reload_caddy

    cat <<EOF

================================================================================
Видеохостинг удалён: контейнеры остановлены, сервисы и блок Caddy убраны,
каталог ${APP_DIR} удалён. Бэкапы compose и Caddyfile с меткой времени
остались рядом — можно откатиться вручную.
================================================================================
EOF
}

case "${1:-}" in
    --install)   action_install ;;
    --uninstall) action_uninstall ;;
    -h|--help|"") usage; [[ -z "${1:-}" ]] && exit 1 || exit 0 ;;
    *) echo "Неизвестный ключ: $1" >&2; usage; exit 1 ;;
esac
