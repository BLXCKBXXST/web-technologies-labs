#!/usr/bin/env bash
# deploy.sh — деплой и снос сайта lab13/les-3 на собственном сервере за Caddy.
#
# Использование:
#   ./deploy.sh --install     # развернуть сайт (nginx-контейнер + блок в Caddyfile)
#   ./deploy.sh --uninstall   # снести сайт (контейнер, файлы, блок в Caddyfile)
#
# Требует уже установленного Caddy на сервере (контейнер caddy в общем
# /opt/stack/docker-compose.yml). Это временная инфраструктура под показ
# учебного задания — после демонстрации запустить --uninstall.
set -euo pipefail

STACK_DIR="/opt/stack"
COMPOSE_FILE="${STACK_DIR}/docker-compose.yml"
CADDY_FILE="${STACK_DIR}/caddy/Caddyfile"
MARVEL_DIR="${STACK_DIR}/marvel"
SITE_DIR="${MARVEL_DIR}/site"
USER_NAME="$(id -un)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_SOURCE="${SCRIPT_DIR}/les-3"

usage() {
    cat <<EOF
Usage: $(basename "$0") --install | --uninstall

  --install     Развернуть Marvel-сайт: rsync исходников в ${SITE_DIR},
                добавить сервис marvel (nginx:alpine) в общий docker-compose.yml,
                дописать поддомен в Caddyfile, перезагрузить Caddy.

  --uninstall   Снести Marvel-сайт: остановить и удалить контейнер marvel,
                удалить сервис из docker-compose.yml, удалить блок поддомена
                из Caddyfile, удалить ${MARVEL_DIR}, перезагрузить Caddy.

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
        echo "ОШИБКА: ${COMPOSE_FILE} не найден. Сначала запустите home-server/scripts/50-install-caddy-proxy.sh." >&2
        exit 1
    fi
    if [[ ! -f "${CADDY_FILE}" ]]; then
        echo "ОШИБКА: ${CADDY_FILE} не найден. Сначала запустите home-server/scripts/50-install-caddy-proxy.sh." >&2
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

action_install() {
    require_caddy_stack

    prompt_default "Домен для Marvel-сайта"        "marvel.server34.netcraze.club" MARVEL_DOMAIN
    prompt_default "Каталог с исходниками сайта"   "${DEFAULT_SOURCE}"             SOURCE_DIR

    if [[ ! -d "${SOURCE_DIR}" ]]; then
        echo "ОШИБКА: каталог исходников ${SOURCE_DIR} не существует." >&2
        exit 1
    fi
    if [[ ! -f "${SOURCE_DIR}/index.html" ]]; then
        echo "ОШИБКА: в ${SOURCE_DIR} нет index.html — это не Marvel-сайт?" >&2
        exit 1
    fi

    echo "==> Бэкаплю docker-compose.yml и Caddyfile..."
    local stamp; stamp="$(date +%Y%m%d-%H%M%S)"
    cp -a "${COMPOSE_FILE}" "${COMPOSE_FILE}.bak.${stamp}"
    cp -a "${CADDY_FILE}"   "${CADDY_FILE}.bak.${stamp}"

    echo "==> Создаю каталог сайта ${SITE_DIR}..."
    sudo -A mkdir -p "${SITE_DIR}"
    sudo -A chown -R "${USER_NAME}:${USER_NAME}" "${MARVEL_DIR}"

    echo "==> Синхронизирую исходники: ${SOURCE_DIR} -> ${SITE_DIR}..."
    rsync -a --delete \
        --exclude='.git' --exclude='node_modules' --exclude='*.swp' \
        "${SOURCE_DIR}/" "${SITE_DIR}/"

    if grep -qE '^[[:space:]]+marvel:[[:space:]]*$' "${COMPOSE_FILE}"; then
        echo "==> Сервис marvel уже описан в ${COMPOSE_FILE} — пропускаю добавление."
    else
        echo "==> Добавляю сервис marvel в ${COMPOSE_FILE}..."
        cat >>"${COMPOSE_FILE}" <<'EOF'

  marvel:
    image: nginx:alpine
    container_name: marvel
    restart: unless-stopped
    volumes:
      - ./marvel/site:/usr/share/nginx/html:ro
EOF
    fi

    if grep -qF "${MARVEL_DOMAIN} {" "${CADDY_FILE}"; then
        echo "==> Блок ${MARVEL_DOMAIN} уже есть в ${CADDY_FILE} — пропускаю."
    else
        echo "==> Дописываю блок ${MARVEL_DOMAIN} в ${CADDY_FILE}..."
        cat >>"${CADDY_FILE}" <<EOF

${MARVEL_DOMAIN} {
    encode gzip
    reverse_proxy marvel:80
}
EOF
    fi

    echo "==> docker compose config (валидация)..."
    ( cd "${STACK_DIR}" && docker compose config >/dev/null )

    echo "==> docker compose pull marvel..."
    ( cd "${STACK_DIR}" && docker compose pull marvel )

    echo "==> docker compose up -d marvel..."
    ( cd "${STACK_DIR}" && docker compose up -d marvel )

    reload_caddy

    cat <<EOF

================================================================================
Marvel-сайт развёрнут.

Публичный URL:
  https://${MARVEL_DOMAIN}  -> marvel:80 (nginx)

Дальнейшие шаги:
  1. Убедитесь, что DNS A/CNAME ${MARVEL_DOMAIN} указывает на ваш внешний IP
     (обычно — CNAME на server34.netcraze.club):
       nslookup ${MARVEL_DOMAIN}
  2. Откройте https://${MARVEL_DOMAIN} в браузере. При первом запросе Caddy
     ~30 секунд выпускает TLS-сертификат Let's Encrypt; после этого открывается
     сайт с зелёным замком.
  3. Логи: docker logs -f caddy   и   docker logs -f marvel

Снести после демонстрации:
  ./deploy.sh --uninstall

ВНИМАНИЕ: home-server/scripts/50-install-caddy-proxy.sh при перезапуске затирает
Caddyfile целиком. Если он будет перезапущен — повторите ./deploy.sh --install.
================================================================================
EOF
}

action_uninstall() {
    require_caddy_stack

    prompt_default "Домен для удаления" "marvel.server34.netcraze.club" MARVEL_DOMAIN

    echo "==> Бэкаплю docker-compose.yml и Caddyfile..."
    local stamp; stamp="$(date +%Y%m%d-%H%M%S)"
    cp -a "${COMPOSE_FILE}" "${COMPOSE_FILE}.bak.${stamp}"
    cp -a "${CADDY_FILE}"   "${CADDY_FILE}.bak.${stamp}"

    if ( cd "${STACK_DIR}" && docker compose ps --services 2>/dev/null | grep -qx marvel ); then
        echo "==> Останавливаю и удаляю контейнер marvel..."
        ( cd "${STACK_DIR}" && docker compose stop marvel && docker compose rm -f marvel )
    else
        echo "==> Контейнер marvel не запущен — пропускаю остановку."
    fi

    if grep -qE '^[[:space:]]+marvel:[[:space:]]*$' "${COMPOSE_FILE}"; then
        echo "==> Удаляю сервис marvel из ${COMPOSE_FILE}..."
        # Стираем блок от строки "  marvel:" до следующего сервиса (две ведущих пробела + слово + ":")
        # или до конца файла. Awk-фильтр на потоке.
        awk '
            BEGIN { skip = 0 }
            /^[[:space:]]+marvel:[[:space:]]*$/ { skip = 1; next }
            skip && /^[[:space:]]{2}[A-Za-z0-9_-]+:[[:space:]]*$/ { skip = 0 }
            skip == 0 { print }
        ' "${COMPOSE_FILE}" > "${COMPOSE_FILE}.tmp"
        mv "${COMPOSE_FILE}.tmp" "${COMPOSE_FILE}"
    else
        echo "==> Сервис marvel отсутствует в ${COMPOSE_FILE} — пропускаю."
    fi

    if grep -qF "${MARVEL_DOMAIN} {" "${CADDY_FILE}"; then
        echo "==> Удаляю блок ${MARVEL_DOMAIN} из ${CADDY_FILE}..."
        # Стираем от строки "<domain> {" до соответствующей "}" в начале строки.
        awk -v dom="${MARVEL_DOMAIN}" '
            BEGIN { skip = 0 }
            $0 ~ "^"dom" \\{$" { skip = 1; next }
            skip && /^\}[[:space:]]*$/ { skip = 0; next }
            skip == 0 { print }
        ' "${CADDY_FILE}" > "${CADDY_FILE}.tmp"
        mv "${CADDY_FILE}.tmp" "${CADDY_FILE}"
    else
        echo "==> Блок ${MARVEL_DOMAIN} отсутствует в ${CADDY_FILE} — пропускаю."
    fi

    if [[ -d "${MARVEL_DIR}" ]]; then
        echo "==> Удаляю каталог ${MARVEL_DIR}..."
        sudo -A rm -rf "${MARVEL_DIR}"
    else
        echo "==> Каталог ${MARVEL_DIR} отсутствует — пропускаю."
    fi

    echo "==> docker compose config (валидация)..."
    ( cd "${STACK_DIR}" && docker compose config >/dev/null )

    reload_caddy

    cat <<EOF

================================================================================
Marvel-сайт удалён.

Что сделано:
  - контейнер marvel остановлен и удалён;
  - сервис marvel удалён из ${COMPOSE_FILE};
  - блок ${MARVEL_DOMAIN} удалён из ${CADDY_FILE};
  - каталог ${MARVEL_DIR} удалён;
  - Caddy перечитан, поддомен больше не отвечает.

Бэкапы compose и Caddyfile с меткой времени остались рядом — можно откатиться
вручную, если что-то пошло не так.
================================================================================
EOF
}

case "${1:-}" in
    --install)   action_install ;;
    --uninstall) action_uninstall ;;
    -h|--help|"") usage; [[ -z "${1:-}" ]] && exit 1 || exit 0 ;;
    *) echo "Неизвестный ключ: $1" >&2; usage; exit 1 ;;
esac
