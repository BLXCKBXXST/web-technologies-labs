#!/usr/bin/env bash
# =============================================================
#  Практическая работа №4 — Клиентская ВМ
#  Подсказки и подготовка Desktop1
#
#  Запускать: sudo bash desktop_lab4_prepare.sh
#  ВМ: Desktop1 (Ubuntu Desktop)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №4 — Подготовка клиентской ВМ"
echo " Hostname : ${DESKTOP_HOSTNAME}"
echo " Шлюз/DNS : 192.168.${N}.1"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Hostname
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: установка hostname ---"
echo "[ИНФО] Старый hostname: $(hostname)"
hostnamectl set-hostname "${DESKTOP_HOSTNAME}"

cat >/etc/hosts <<EOF
127.0.0.1   localhost
127.0.1.1   ${DESKTOP_HOSTNAME}
EOF

echo "[OK] hostname = $(hostname)"

# ------------------------------------------------------------------
# ШАГ 2. Подсказки по настройке сети в GUI
# ------------------------------------------------------------------
echo
echo "================================================================"
echo " [ИНТЕРАКТИВНЫЙ ШАГ] Настрой сетевой интерфейс в GUI Desktop:"
echo
echo " Settings → Network → Wired → шестерёнка → IPv4"
echo
echo " Вариант А — СТАТИЧЕСКИЙ IP (до включения DHCP на сервере):"
echo "   IPv4 Method : Manual"
echo "   Address     : 192.168.${N}.10"
echo "   Netmask     : 255.255.255.0"
echo "   Gateway     : 192.168.${N}.1"
echo "   DNS         : 192.168.${N}.1"
echo
echo " Вариант Б — DHCP (после выполнения gateway_lab4_dhcp.sh):"
echo "   IPv4 Method : Automatic (DHCP)"
echo
echo " Не забудь после изменений — выключить/включить соединение!"
echo
echo "----------------------------------------------------------------"
echo " Проверка:"
echo "   ping 192.168.${N}.1    # должен отвечать шлюз"
echo "   ping ya.ru              # должен отвечать Интернет"
echo "================================================================"
