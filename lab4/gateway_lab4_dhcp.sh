#!/usr/bin/env bash
# =============================================================
#  Практическая работа №4 — Часть 2
#  Установка и настройка DHCP-сервера (isc-dhcp-server)
#
#  Запускать: sudo bash gateway_lab4_dhcp.sh
#  ВМ: gateway (Ubuntu Server 20.04)
#  Предусловие: gateway_lab4_net.sh уже выполнен
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

DHCP_DEFAULT="/etc/default/isc-dhcp-server"
DHCP_CONF="/etc/dhcp/dhcpd.conf"

echo "================================================================"
echo " Лабораторная №4 — DHCP на ${SERVER_HOSTNAME}"
echo " Интерфейс : ${NET_IF_INT}"
echo " Подсеть   : 192.168.${N}.0/24"
echo " Диапазон  : 192.168.${N}.10 — 192.168.${N}.254"
echo " Шлюз/DNS  : 192.168.${N}.1"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Установка isc-dhcp-server
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: установка isc-dhcp-server ---"
apt-get update -y
apt-get install -y isc-dhcp-server
echo "[OK] isc-dhcp-server установлен."

# ------------------------------------------------------------------
# ШАГ 2. Указываем интерфейс в /etc/default/isc-dhcp-server
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: прописываем интерфейс ${NET_IF_INT} ---"

if [[ -f "${DHCP_DEFAULT}" ]]; then
  cp "${DHCP_DEFAULT}" "${DHCP_DEFAULT}.bak_lab4"
  echo "[РЕЗЕРВ] ${DHCP_DEFAULT}.bak_lab4 создан."
fi

if grep -q '^INTERFACESv4=' "${DHCP_DEFAULT}" 2>/dev/null; then
  sed -i "s|^INTERFACESv4=.*|INTERFACESv4=\"${NET_IF_INT}\"|" "${DHCP_DEFAULT}"
else
  echo "INTERFACESv4=\"${NET_IF_INT}\"" >> "${DHCP_DEFAULT}"
fi

echo "[OK] Содержимое ${DHCP_DEFAULT}:"
grep 'INTERFACES' "${DHCP_DEFAULT}"

# ------------------------------------------------------------------
# ШАГ 3. Создание конфигурационного файла dhcpd.conf
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: настройка ${DHCP_CONF} ---"

if [[ -f "${DHCP_CONF}" ]]; then
  cp "${DHCP_CONF}" "${DHCP_CONF}.example_lab4"
  echo "[РЕЗЕРВ] ${DHCP_CONF}.example_lab4 создан."
fi

cat >"${DHCP_CONF}" <<EOF
authoritative;

subnet 192.168.${N}.0 netmask 255.255.255.0 {
  range 192.168.${N}.10 192.168.${N}.254;
  option domain-name-servers 192.168.${N}.1;
  option routers 192.168.${N}.1;
  option broadcast-address 192.168.${N}.255;
  default-lease-time 604800;
  max-lease-time 604800;
}

# Пример резервации IP за MAC-адресом (раскомментировать при необходимости):
# host desktop01 {
#   hardware ethernet 00:01:8a:e3:58:92;
#   fixed-address 192.168.${N}.51;
# }
EOF

echo "[OK] ${DHCP_CONF} записан:"
cat "${DHCP_CONF}"

# ------------------------------------------------------------------
# ШАГ 4. Запуск сервиса
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: запуск isc-dhcp-server ---"
systemctl restart isc-dhcp-server
sleep 2

echo "[ИНФО] Статус сервиса:"
systemctl --no-pager --full status isc-dhcp-server || true

if systemctl is-active --quiet isc-dhcp-server; then
  echo "[OK] isc-dhcp-server запущен и работает."
else
  echo "[ОШИБКА] isc-dhcp-server не запустился!"
  echo "  Смотри причину: tail -50 /var/log/syslog"
  echo "  Частые проблемы:"
  echo "    - Пропущен ';' в строках dhcpd.conf"
  echo "    - Диапазон не входит в указанную подсеть"
  echo "    - Неверный INTERFACESv4 в ${DHCP_DEFAULT}"
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 5. Итог + подсказки по проверке
# ------------------------------------------------------------------
echo
echo "================================================================"
echo " Часть 2 завершена! DHCP-сервер работает."
echo
echo " Проверка на Desktop1:"
echo "   1. В настройках сети выбери IPv4 → Automatic (DHCP)."
echo "   2. Отключи и включи соединение."
echo "   3. Убедись, что получен IP из диапазона:"
echo "      192.168.${N}.10 — 192.168.${N}.254"
echo
echo " Тесты с Desktop:"
echo "   ping 192.168.${N}.1"
echo "   ping ya.ru"
echo
echo " Смотреть выданные аренды:"
echo "   cat /var/lib/dhcp/dhcpd.leases"
echo
echo " При ошибках:"
echo "   tail -50 /var/log/syslog"
echo "   systemctl restart isc-dhcp-server"
echo "================================================================"
