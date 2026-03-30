#!/usr/bin/env bash
# =============================================================
#  Практическая работа №6 — systemd-сервисы и первый запуск Seafile
#
#  Запускать: sudo bash seafile_services.sh
#  ВМ: seafile (Ubuntu Server 22.04)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №6 — systemd-юниты и первый запуск Seafile"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

INSTALL_DIR="${SEAFILE_DIR}/seafile-server-${SEAFILE_VER}"
SEAFILE_SVC="/etc/systemd/system/seafile.service"
SEAHUB_SVC="/etc/systemd/system/seahub.service"

if [[ ! -d "${INSTALL_DIR}" ]]; then
  echo "[ОШИБКА] ${INSTALL_DIR} не найден. Убедись, что выполнен seafile_install.sh"
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Создание systemd unit для seafile
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: создание ${SEAFILE_SVC} ---"

cat > "${SEAFILE_SVC}" <<EOF
[Unit]
Description=Seafile
After=mariadb.service
After=network.target

[Service]
Type=forking
ExecStart=${INSTALL_DIR}/seafile.sh start
ExecStop=${INSTALL_DIR}/seafile.sh stop

[Install]
WantedBy=multi-user.target
EOF

echo "[OK] ${SEAFILE_SVC} создан."

# ------------------------------------------------------------------
# ШАГ 2. Создание systemd unit для seahub
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: создание ${SEAHUB_SVC} ---"

cat > "${SEAHUB_SVC}" <<EOF
[Unit]
Description=Seahub (Seafile web UI)
After=seafile.service

[Service]
Type=forking
ExecStart=${INSTALL_DIR}/seahub.sh start
ExecStop=${INSTALL_DIR}/seahub.sh stop

[Install]
WantedBy=multi-user.target
EOF

echo "[OK] ${SEAHUB_SVC} создан."

# ------------------------------------------------------------------
# ШАГ 3. Включение автозапуска
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: systemctl daemon-reload + enable ---"
systemctl daemon-reload
systemctl enable seafile
systemctl enable seahub
echo "[OK] Автозапуск seafile и seahub включён."

# ------------------------------------------------------------------
# ШАГ 4. Первый запуск seafile.sh
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: запуск seafile.sh ---"
"${INSTALL_DIR}/seafile.sh" start
echo "[OK] seafile.sh запущен."

echo
echo "================================================================"
echo " [ИНТЕРАКТИВНЫЙ ШАГ] Первый запуск seahub — создание admin-аккаунта"
echo ""
echo " Выполни вручную:"
echo "   ${INSTALL_DIR}/seahub.sh start"
echo ""
echo " При первом запуске тебя спросят:"
echo "   E-mail администратора : admin@${DOMAIN}"
echo "   Пароль                : придумай и запомни"
echo "   Подтверждение пароля  : повтори пароль"
echo ""
echo " После запуска seahub веб-интерфейс доступен с Desktop:"
echo "   http://seafile.lan"
echo "   Логин : admin@${DOMAIN}"
echo ""
echo " Для управления сервисами после перезагрузки:"
echo "   sudo systemctl start seafile seahub"
echo "   sudo systemctl stop  seafile seahub"
echo "   sudo systemctl status seafile seahub"
echo "================================================================"
