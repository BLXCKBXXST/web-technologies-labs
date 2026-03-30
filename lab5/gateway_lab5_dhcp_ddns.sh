#!/usr/bin/env bash
# =============================================================
#  Практическая работа №5 — Часть 2
#  Настройка DHCP (isc-dhcp-server) с динамическим обновлением
#  DNS-зон через rndc-ключ (DDNS)
#
#  Запускать ПОСЛЕ gateway_lab5.sh и перезагрузки
#  Запускать: sudo bash gateway_lab5_dhcp_ddns.sh
#  ВМ: gateway (Ubuntu Server)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №5 — DHCP+DDNS на ${SERVER_HOSTNAME}"
echo " Домен   : ${DOMAIN}"
echo " Диапазон: 192.168.${N}.10 — 192.168.${N}.254"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

DHCP_CONF="/etc/dhcp/dhcpd.conf"

if [[ ! -f "$DHCP_CONF" ]]; then
  echo "[ОШИБКА] ${DHCP_CONF} не найден. Убедись, что isc-dhcp-server установлен (лаб.4)." >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Копирование rndc.key для DHCP
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: копирование rndc.key для dhcp ---"

if [[ ! -f /etc/bind/rndc.key ]]; then
  echo "[ОШИБКА] /etc/bind/rndc.key не найден. Проверь установку bind9." >&2
  exit 1
fi

mkdir -p /etc/dhcp/ddns-keys
cp -f /etc/bind/rndc.key /etc/dhcp/ddns-keys/rndc.key
chown root:root /etc/dhcp/ddns-keys/rndc.key
chmod 640 /etc/dhcp/ddns-keys/rndc.key
echo "[OK] rndc.key скопирован в /etc/dhcp/ddns-keys/"

# ------------------------------------------------------------------
# ШАГ 2. Перезапись dhcpd.conf
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: перезапись ${DHCP_CONF} ---"
cp "$DHCP_CONF" "${DHCP_CONF}.bak_lab5"
echo "[РЕЗЕРВ] ${DHCP_CONF}.bak_lab5"

cat >"$DHCP_CONF" <<EOF
authoritative;

include "/etc/dhcp/ddns-keys/rndc.key";
ddns-updates on;
ddns-update-style standard;
ddns-domainname "${DOMAIN}";

zone ${DOMAIN}. {
    primary 192.168.${N}.1;
    key rndc-key;
}

zone ${N}.168.192.in-addr.arpa. {
    primary 192.168.${N}.1;
    key rndc-key;
}

subnet 192.168.${N}.0 netmask 255.255.255.0 {
    range 192.168.${N}.10 192.168.${N}.254;
    option domain-name-servers 192.168.${N}.1;
    option domain-name "${DOMAIN}";
    option routers 192.168.${N}.1;
    option broadcast-address 192.168.${N}.255;
    default-lease-time 604800;
    max-lease-time 604800;
}
EOF

echo "[OK] dhcpd.conf перезаписан."

# ------------------------------------------------------------------
# ШАГ 3. Перезапуск сервисов и проверка
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: перезапуск bind9 и isc-dhcp-server ---"
systemctl restart bind9
sleep 1
service isc-dhcp-server restart
sleep 2

echo
echo "[ИНФО] Статус isc-dhcp-server:"
service isc-dhcp-server status || true

echo
echo "[ИНФО] Статус bind9:"
systemctl --no-pager status bind9 || true

echo
echo "================================================================"
echo " DDNS настроен!"
echo " Подключи Desktop к сети, задай ему hostname, и проверь:"
echo "   nslookup ${DESKTOP_HOSTNAME}"
echo "   nslookup <IP клиента>"
echo " При ошибках: tail -40 /var/log/syslog"
echo "================================================================"
