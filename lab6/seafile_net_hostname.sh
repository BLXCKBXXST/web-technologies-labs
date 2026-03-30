#!/usr/bin/env bash
# =============================================================
#  Практическая работа №6 — Сеть и hostname ВМ seafile
#
#  Запускать: sudo bash seafile_net_hostname.sh
#  ВМ: seafile (Ubuntu Server 22.04) — свежий клон
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №6 — сеть и hostname на ${SEAFILE_HOSTNAME}"
echo " IP     : ${SEAFILE_IP}/24"
echo " Gateway: ${GW_IP}"
echo " DNS    : ${GW_IP}"
echo " Домен  : ${DOMAIN}"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Статический IP через netplan
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: настройка netplan ---"

if [[ -f "${NETPLAN_FILE}" ]]; then
  cp "${NETPLAN_FILE}" "${NETPLAN_FILE}.bak_lab6"
  echo "[РЕЗЕРВ] ${NETPLAN_FILE}.bak_lab6"
fi

cat > "${NETPLAN_FILE}" <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    ${NET_IF}:
      dhcp4: no
      addresses:
        - ${SEAFILE_IP}/24
      gateway4: ${GW_IP}
      nameservers:
        addresses: [${GW_IP}]
        search: [${DOMAIN}]
EOF

netplan apply
echo "[OK] netplan применён."

# ------------------------------------------------------------------
# ШАГ 2. Проверка сети
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: проверка сети ---"
ip a show "${NET_IF}" | grep -A1 "inet " || echo "[ПРЕДУПРЕЖДЕНИЕ] Не вижу IP на ${NET_IF}"

echo "[ИНФО] Пингую gateway (${GW_IP})..."
if ping -c 3 -W 2 "${GW_IP}" >/dev/null 2>&1; then
  echo "[OK] ping gateway — ответ есть."
else
  echo "[ПРЕДУПРЕЖДЕНИЕ] ping gateway не прошёл. Проверь netplan и тип адаптера VirtualBox (Внутренняя сеть intnet)."
fi

echo "[ИНФО] Пингую ya.ru (проверка интернета)..."
if ping -c 3 -W 3 ya.ru >/dev/null 2>&1; then
  echo "[OK] Интернет доступен."
else
  echo "[ПРЕДУПРЕЖДЕНИЕ] Интернет недоступен. Если нужен Интернет — проверь шлюз и лаб.4/5."
fi

# ------------------------------------------------------------------
# ШАГ 3. Hostname и /etc/hosts
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: hostname = ${SEAFILE_HOSTNAME} ---"
hostnamectl set-hostname "${SEAFILE_HOSTNAME}"

cat > /etc/hosts <<EOF
127.0.0.1   localhost
127.0.1.1   ${SEAFILE_HOSTNAME}

${SEAFILE_IP}   ${SEAFILE_HOSTNAME}.${DOMAIN} ${SEAFILE_HOSTNAME}
EOF

echo "[OK] hostname = $(hostname)"
echo "[OK] /etc/hosts обновлён."

echo
echo "================================================================"
echo " Сеть и hostname настроены."
echo " РЕКОМЕНДУЕТСЯ перезагрузить ВМ seafile:"
echo "   sudo reboot"
echo " После перезагрузки — запусти seafile_install.sh"
echo "================================================================"
