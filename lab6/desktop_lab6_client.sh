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
  gir1.2-gtk-3.0 gir1.2-glib-2.0 gir1.2-notify-0.7 libfuse2
echo "[OK] Зависимости установлены."

# ------------------------------------------------------------------
# ШАГ 3. Скачивание Seafile AppImage
# Начиная с v9.0.7 .deb-пакеты для focal не выпускаются;
# официальный формат поставки для Linux — AppImage.
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: скачивание seafile-gui (AppImage) ---"

APPIMAGE_URL="https://github.com/haiwen/seafile-client/releases/download/v9.0.9/Seafile-x86_64.AppImage"
APPIMAGE_FILE="/opt/seafile-gui.AppImage"

if [[ ! -f "${APPIMAGE_FILE}" ]]; then
  wget -c -O "${APPIMAGE_FILE}" "${APPIMAGE_URL}"
else
  echo "[ИНФО] AppImage уже скачан: ${APPIMAGE_FILE}"
fi

chmod +x "${APPIMAGE_FILE}"
echo "[OK] Seafile AppImage скачан: ${APPIMAGE_FILE}"

# ------------------------------------------------------------------
# ШАГ 4. Создание команды запуска и .desktop-файла
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: создание ярлыка запуска ---"

cat > /usr/local/bin/seafile-gui << 'EOF'
#!/bin/bash
exec /opt/seafile-gui.AppImage "$@"
EOF
chmod +x /usr/local/bin/seafile-gui

cat > /usr/share/applications/seafile-gui.desktop << EOF2
[Desktop Entry]
Name=Seafile
Comment=Seafile Desktop Client
Exec=/opt/seafile-gui.AppImage
Icon=seafile
Terminal=false
Type=Application
Categories=Network;FileTransfer;
EOF2
echo "[OK] Команда: seafile-gui | Desktop-ярлык создан."

# ------------------------------------------------------------------
# ШАГ 5. Проверка доступности сервера
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: проверка доступности сервера seafile ---"

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
echo " 1. Запусти приложение: seafile-gui"
echo "    или через меню приложений."
echo " 2. При первом запуске введи:"
echo "      Server URL: http://${SEAFILE_IP}"
echo "      (или http://seafile.lan, если DNS работает)"
echo "      Email : admin@${DOMAIN}"
echo "      Пароль: тот, что задавал при запуске seahub"
echo " 3. Синхронизируй библиотеку и покажи результат преподавателю."
echo "================================================================"
