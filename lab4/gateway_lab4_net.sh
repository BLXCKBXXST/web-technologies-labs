#!/usr/bin/env bash
# =============================================================
#  Практическая работа №4 — Часть 1
#  Настройка сетевых интерфейсов и NAT на сервере gateway
#
#  Запускать: sudo bash gateway_lab4_net.sh
#  ВМ: gateway (Ubuntu Server 20.04)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №4 — сеть + NAT на ${SERVER_HOSTNAME}"
echo " Внешний  : ${NET_IF_EXT}  ${EXT_IP}  gw ${EXT_GW}"
echo " Внутренний: ${NET_IF_INT}  192.168.${N}.1/24"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Проверка наличия интерфейсов
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: проверка сетевых интерфейсов ---"
for iface in "${NET_IF_EXT}" "${NET_IF_INT}"; do
  if ip link show "${iface}" >/dev/null 2>&1; then
    echo "[OK] Интерфейс ${iface} найден."
  else
    echo "[ОШИБКА] Интерфейс ${iface} не найден!"
    echo "         Проверь настройки адаптеров в VirtualBox и имена интерфейсов (ip a)."
    exit 1
  fi
done
echo "[ИНФО] Текущие интерфейсы:"
ip -br a

# ------------------------------------------------------------------
# ШАГ 2. Настройка Netplan
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: запись ${NETPLAN_FILE} ---"

if [[ -f "${NETPLAN_FILE}" ]]; then
  cp "${NETPLAN_FILE}" "${NETPLAN_FILE}.bak_lab4"
  echo "[РЕЗЕРВ] ${NETPLAN_FILE}.bak_lab4 создан."
fi

cat >"${NETPLAN_FILE}" <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    ${NET_IF_EXT}:
      dhcp4: no
      addresses:
        - ${EXT_IP}
      gateway4: ${EXT_GW}
      nameservers:
        addresses: [${EXT_DNS}]
    ${NET_IF_INT}:
      dhcp4: no
      addresses:
        - 192.168.${N}.1/24
EOF

echo "[OK] ${NETPLAN_FILE} записан:"
cat "${NETPLAN_FILE}"

echo
echo "--- Шаг 2a: применение netplan ---"
netplan apply
echo "[OK] netplan apply выполнен."

echo "[ИНФО] Адреса после применения:"
ip -br a

# ------------------------------------------------------------------
# ШАГ 3. Проверка интернета на шлюзе
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: проверка интернета на шлюзе (ping ya.ru) ---"
if ping -c 3 -W 3 ya.ru >/dev/null 2>&1; then
  echo "[OK] Интернет на шлюзе работает."
else
  echo "[ПРЕДУПРЕЖДЕНИЕ] ping ya.ru не прошёл."
  echo "  Проверь: тип адаптера enp0s3 в VirtualBox (должен быть NAT или мост)."
fi

# ------------------------------------------------------------------
# ШАГ 4. Включение IP-forwarding
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: включение ip_forward в /etc/sysctl.conf ---"

if grep -q '^#*net\.ipv4\.ip_forward' /etc/sysctl.conf; then
  sed -i 's/^#\?net\.ipv4\.ip_forward.*/net.ipv4.ip_forward=1/' /etc/sysctl.conf
  echo "[OK] Строка net.ipv4.ip_forward=1 раскомментирована/обновлена."
else
  echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
  echo "[OK] net.ipv4.ip_forward=1 добавлена в конец /etc/sysctl.conf."
fi

sysctl -p /etc/sysctl.conf | grep ip_forward || true

# ------------------------------------------------------------------
# ШАГ 5. Установка iptables-persistent
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: установка iptables-persistent ---"
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y iptables-persistent
echo "[OK] iptables-persistent установлен."

# ------------------------------------------------------------------
# ШАГ 6. Настройка правил iptables (NAT + DNAT DNS)
# ------------------------------------------------------------------
echo
echo "--- Шаг 6: настройка правил iptables ---"

# Полный сброс всех таблиц (filter, nat, mangle) —
# предотвращает дублирование правил при повторном запуске скрипта
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# Политики по умолчанию
iptables -P INPUT   ACCEPT
iptables -P OUTPUT  ACCEPT
iptables -P FORWARD ACCEPT

# MASQUERADE для выхода в интернет через внешний интерфейс
iptables -t nat -A POSTROUTING -o "${NET_IF_EXT}" -j MASQUERADE

# Явный ACCEPT форвардинга из LAN → WAN и обратно
iptables -A FORWARD -i "${NET_IF_INT}" -o "${NET_IF_EXT}" -j ACCEPT
iptables -A FORWARD -i "${NET_IF_EXT}" -o "${NET_IF_INT}" -m state --state RELATED,ESTABLISHED -j ACCEPT

# Запрет петли внешний → внешний
iptables -A FORWARD -i "${NET_IF_EXT}" -o "${NET_IF_EXT}" -j REJECT

# MSS clamp (фикс для проблем с MTU)
iptables -I FORWARD 1 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

# DNAT DNS-запросов из локальной сети → Google 8.8.8.8
iptables -t nat -A PREROUTING -i "${NET_IF_INT}" -p tcp --dport 53 -j DNAT --to-destination 8.8.8.8:53
iptables -t nat -A PREROUTING -i "${NET_IF_INT}" -p udp --dport 53 -j DNAT --to-destination 8.8.8.8:53

# Сохранение правил
mkdir -p "$(dirname "${IPTABLES_RULES}")"
iptables-save > "${IPTABLES_RULES}"
echo "[OK] Правила сохранены в ${IPTABLES_RULES}."

echo
echo "[ИНФО] Активные правила FORWARD + NAT:"
iptables -L FORWARD -n -v --line-numbers
iptables -t nat -L -n -v

# ------------------------------------------------------------------
# ШАГ 7. Итог
# ------------------------------------------------------------------
echo
echo "================================================================"
echo " Часть 1 завершена!"
echo
echo " Следующий шаг — настроить Desktop1 на статический IP:"
echo "   IP      : 192.168.${N}.10"
echo "   Mask    : 255.255.255.0"
echo "   Gateway : 192.168.${N}.1"
echo "   DNS     : 192.168.${N}.1"
echo
echo " Затем запусти: sudo bash gateway_lab4_dhcp.sh"
echo "================================================================"
