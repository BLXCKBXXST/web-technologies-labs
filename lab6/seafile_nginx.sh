#!/usr/bin/env bash
# =============================================================
#  Практическая работа №6 — Установка и настройка nginx
#
#  Запускать: sudo bash seafile_nginx.sh
#  ВМ: seafile (Ubuntu Server 22.04)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №6 — установка nginx как reverse-proxy для Seafile"
echo " Listen: ${SEAFILE_IP}:80"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

NGINX_CONF="/etc/nginx/sites-available/seafile.conf"
NGINX_LINK="/etc/nginx/sites-enabled/seafile.conf"

# ------------------------------------------------------------------
# ШАГ 1. Установка nginx
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: установка nginx ---"
apt-get install -y nginx
echo "[OK] nginx установлен: $(nginx -v 2>&1)"

# ------------------------------------------------------------------
# ШАГ 2. Конфигурация виртуального хоста
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: создание конфига ${NGINX_CONF} ---"

cat > "${NGINX_CONF}" <<EOF
server {
    listen ${SEAFILE_IP}:80;
    server_name seafile.lan;
    index index.html;

    location / {
        proxy_pass         http://127.0.0.1:8000;
        proxy_set_header   Host              \$host;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_buffering    off;
    }
}
EOF

echo "[OK] Конфиг создан."

# ------------------------------------------------------------------
# ШАГ 3. Симлинк и удаление default
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: симлинк sites-enabled ---"
ln -sf "${NGINX_CONF}" "${NGINX_LINK}"
echo "[OK] Симлинк создан: ${NGINX_LINK}"

if [[ -f /etc/nginx/sites-enabled/default ]]; then
  rm /etc/nginx/sites-enabled/default
  echo "[OK] Удалён дефолтный конфиг nginx."
fi

# ------------------------------------------------------------------
# ШАГ 4. Проверка конфига и перезапуск nginx
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: проверка конфига nginx ---"
if nginx -t 2>&1; then
  echo "[OK] Конфиг nginx валиден."
else
  echo "[ОШИБКА] Ошибка в конфиге nginx. Проверь: nano ${NGINX_CONF}"
  exit 1
fi

service nginx restart
echo "[OK] nginx перезапущен."

echo "[ИНФО] nginx слушает на:"
ss -tnlp | grep :80 || echo "[ПРЕДУПРЕЖДЕНИЕ] :80 не прослушивается"

echo
echo "================================================================"
echo " nginx настроен."
echo " Следующий шаг: запусти sudo bash seafile_services.sh"
echo "================================================================"
