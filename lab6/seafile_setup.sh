#!/usr/bin/env bash
# =============================================================
#  Практическая работа №6 — Подготовка к запуску setup-seafile-mysql.sh
#
#  Запускать: sudo bash seafile_setup.sh
#  ВМ: seafile (Ubuntu Server 22.04)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №6 — подготовка к запуску установщика Seafile"
echo " Seafile IP : ${SEAFILE_IP}"
echo " Версия     : ${SEAFILE_VER}"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

INSTALL_DIR="${SEAFILE_DIR}/seafile-server-${SEAFILE_VER}"

if [[ ! -d "${INSTALL_DIR}" ]]; then
  echo "[ОШИБКА] Каталог ${INSTALL_DIR} не найден."
  echo "         Сначала запусти: sudo bash seafile_install.sh"
  exit 1
fi

if ! systemctl is-active --quiet mariadb; then
  echo "[ОШИБКА] MariaDB не запущена. Запусти: systemctl start mariadb"
  exit 1
fi

echo "[OK] MariaDB запущена."
echo "[OK] Каталог установки: ${INSTALL_DIR}"

echo
echo "================================================================"
echo " [ИНТЕРАКТИВНЫЙ ШАГ] Запуск интерактивного установщика Seafile"
echo ""
echo " Выполни вручную (можно без sudo — под пользователем ${SEAFILE_SYSTEM_USER}):"
echo ""
echo "   cd ${INSTALL_DIR}"
echo "   ./setup-seafile-mysql.sh"
echo ""
echo " Подсказки по вводу:"
echo "   Server name        : seafile"
echo "   Server IP/Domain   : ${SEAFILE_IP}"
echo "   Seafile server port: 8082  (просто Enter)"
echo "   [1 or 2]           : 1     (Create new databases)"
echo "   MySQL host         : localhost  (Enter)"
echo "   MySQL port         : 3306       (Enter)"
echo "   MySQL root password: <тот пароль, что задавал mysqladmin>"
echo "   Остальные вопросы  : Enter (значения по умолчанию)"
echo ""
echo " После успешного завершения установщика — запусти:"
echo "   sudo bash seafile_nginx.sh"
echo "================================================================"
