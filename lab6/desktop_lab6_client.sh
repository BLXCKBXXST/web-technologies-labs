#!/usr/bin/env bash
# =============================================================
#  Практическая работа №6 — Установка Seafile-клиента на Desktop
#
#  Запускать: sudo bash desktop_lab6_client.sh
#  ВМ: Desktop (Ubuntu Desktop, из лаб.5)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №6 — установка Seafile GUI-клиента на Desktop"
echo " Сервер : http://seafile.lan  (${SEAFILE_IP})"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Обновление пакетов
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: apt-get update ---"
apt-get update -y
echo "[OK] Пакеты обновлены."

# ------------------------------------------------------------------
# ШАГ 2. Установка зависимостей
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: установка зависимостей ---"
apt-get install -y wget libsecret-1-0 python3 python3-gi \
  gir1.2-gtk-3.0 gir1.2-glib-2.0 gir1.2-notify-0.7
echo "[OK] Зависимости установлены."

# ------------------------------------------------------------------
# ШАГ 3. Скачивание и установка seafile-gui .deb
# PPA ppa:seafile/seafile-client для focal удалён,
# используем последний .deb с GitHub Releases
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: скачивание seafile-gui ---"

DEB_URL="https://github.com/haiwen/seafile-client/releases/download/v9.0.6/seafile-gui_9.0.6-focal_amd64.deb"
DEB_FILE="/tmp/seafile-gui.deb"

if [[ ! -f "${DEB_FILE}" ]]; then
  wget -O "${DEB_FILE}" "${DEB_URL}"
else
  echo "[ИНФО] Архив уже скачан."
fi

dpkg -i "${DEB_FILE}" || apt-get install -f -y
echo "[OK] Seafile GUI-клиент установлен."

# ------------------------------------------------------------------
# ШАГ 4. Проверка доступности сервера
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: проверка доступности сервера seafile ---"

if ping -c 3 -W 2 "${SEAFILE_HOSTNAME}" >/dev/null 2>&1; then
  echo "[OK] ping ${SEAFILE_HOSTNAME} (${SEAFILE_IP}) — доступен."
else
  echo "[ПРЕДУПРЕЖДЕНИЕ] ping ${SEAFILE_HOSTNAME} не прошёл."
  echo "                 Проверь DNS (nslookup seafile) и сетевые настройки."
fi

echo
echo "================================================================"
echo " Seafile-клиент установлен."
echo ""
echo " [Дальнейшие шаги]"
echo " 1. Запусти приложение Seafile через меню приложений."
echo " 2. При первом запуске введи:"
echo "      Server URL: http://${SEAFILE_IP}"
echo "      (или http://seafile.lan, если DNS работает)"
echo "      Email : admin@${DOMAIN}"
echo "      Пароль: тот, что задавал при запуске seahub"
echo " 3. Синхронизируй библиотеку и покажи результат преподавателю."
echo "================================================================"
