#!/usr/bin/env bash
# =============================================================
#  Практическая работа №8 — WordPress
#  Проверка после установки
#
#  Запускать: sudo bash wordpress_lab8_post.sh
#  ВМ: wordpress (192.168.N.6)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №8 — Проверка WordPress-сервера"
echo " FQDN  : ${WP_FQDN}"
echo " IP    : ${WP_IP}"
echo " Домен : ${DOMAIN}"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Статус сервисов
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: статус сервисов ---"

for svc in apache2 mariadb; do
  if systemctl is-active --quiet "${svc}"; then
    echo "[OK] ${svc} — запущен"
  else
    echo "[ОШИБКА] ${svc} — НЕ запущен" >&2
  fi
done

# ------------------------------------------------------------------
# ШАГ 2. Проверка открытых портов
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: проверка открытых портов ---"

for port in 80 3306; do
  if ss -tlnp | grep -q ":${port}"; then
    echo "[OK] Порт ${port} слушается"
  else
    echo "[ИНФО] Порт ${port} не обнаружен"
  fi
done

# ------------------------------------------------------------------
# ШАГ 3. Проверка доступности WordPress
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: проверка HTTP-ответа WordPress ---"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "http://${WP_IP}/" 2>/dev/null || echo "000")
if [[ "${HTTP_CODE}" == "200" || "${HTTP_CODE}" == "301" || "${HTTP_CODE}" == "302" ]]; then
  echo "[OK] HTTP-ответ от http://${WP_IP}/ — код ${HTTP_CODE}"
elif [[ "${HTTP_CODE}" == "302" ]]; then
  echo "[OK] Редирект (${HTTP_CODE}) — WordPress установлен"
else
  echo "[ИНФО] HTTP-код: ${HTTP_CODE} — возможно WordPress ещё не установлен через браузер"
fi

# Проверка wp-login.php
LOGIN_CODE=$(curl -s -o /dev/null -w "%{http_code}" "http://${WP_IP}/wp-login.php" 2>/dev/null || echo "000")
if [[ "${LOGIN_CODE}" == "200" ]]; then
  echo "[OK] wp-login.php доступен (код 200)"
else
  echo "[ИНФО] wp-login.php — код ${LOGIN_CODE}"
fi

# ------------------------------------------------------------------
# ШАГ 4. Проверка файлов WordPress
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: проверка файлов WordPress ---"

if [[ -f /var/www/html/wp-config.php ]]; then
  echo "[OK] wp-config.php существует"
else
  echo "[ОШИБКА] wp-config.php не найден в /var/www/html/" >&2
fi

if [[ -d /var/www/html/wp-content ]]; then
  echo "[OK] Каталог wp-content существует"
else
  echo "[ОШИБКА] wp-content не найден" >&2
fi

# ------------------------------------------------------------------
# ШАГ 5. Проверка БД
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: проверка базы данных ---"

if mysql -u "${DB_USER}" -p"${DB_PASSWORD}" -e "USE ${DB_NAME};" 2>/dev/null; then
  echo "[OK] БД '${DB_NAME}' доступна пользователю '${DB_USER}'"
else
  echo "[ОШИБКА] Не удалось подключиться к БД '${DB_NAME}' от '${DB_USER}'" >&2
fi

echo
echo "================================================================"
echo " [ГОТОВО] Проверка завершена."
echo
echo " Панель администратора WordPress:"
echo "   http://${WP_IP}/wp-admin"
echo "   или http://${WP_FQDN}/wp-admin"
echo "================================================================"
