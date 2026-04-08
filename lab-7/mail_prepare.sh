#!/usr/bin/env bash
# =============================================================
#  Практическая работа №7 — Подготовка ВМ mail
#  Hostname, IP, /etc/hosts, resolv.conf
#
#  Запускать: sudo bash mail_prepare.sh
#  ВМ: mail (Ubuntu Server 22.04, Internal Network intnet)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №7 — Подготовка mail-сервера"
echo " Hostname : ${MAIL_FQDN}"
echo " IP       : ${MAIL_IP}"
echo " DNS/GW   : ${GW_IP}"
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
echo "[ИНФО] Текущий hostname: $(hostname)"
hostnamectl set-hostname "${MAIL_FQDN}"
echo "[OK] hostname = $(hostname)"

# ------------------------------------------------------------------
# ШАГ 2. /etc/hosts
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: обновление /etc/hosts ---"
cp /etc/hosts /etc/hosts.bak_lab7
echo "[РЕЗЕРВ] /etc/hosts.bak_lab7"

cat >/etc/hosts <<EOF
127.0.0.1   ${MAIL_FQDN} ${MAIL_HOSTNAME} localhost
${MAIL_IP}   ${MAIL_FQDN} ${MAIL_HOSTNAME}
EOF

echo "[OK] /etc/hosts обновлён:"
cat /etc/hosts

# ------------------------------------------------------------------
# ШАГ 3. Статический IP через netplan
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: настройка статического IP (netplan) ---"
mkdir -p "$(dirname "${NETPLAN_FILE}")"

# Резерв существующего файла если есть
if [[ -f "${NETPLAN_FILE}" ]]; then
  cp "${NETPLAN_FILE}" "${NETPLAN_FILE}.bak_lab7"
  echo "[РЕЗЕРВ] ${NETPLAN_FILE}.bak_lab7"
fi

# Также резервируем дефолтный installer-config если существует
DEFAULT_NP="/etc/netplan/00-installer-config.yaml"
if [[ -f "${DEFAULT_NP}" ]]; then
  cp "${DEFAULT_NP}" "${DEFAULT_NP}.bak_lab7"
  echo "[РЕЗЕРВ] ${DEFAULT_NP}.bak_lab7"
fi

cat >"${NETPLAN_FILE}" <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    ${NET_IF}:
      dhcp4: no
      addresses: [${MAIL_CIDR}]
      gateway4: ${GW_IP}
      nameservers:
        addresses: [${GW_IP}]
        search: [${DOMAIN}]
EOF

netplan apply
echo "[OK] netplan применён. Текущие адреса:"
ip -4 addr show "${NET_IF}" | grep inet || true

# ------------------------------------------------------------------
# ШАГ 4. Отключение systemd-resolved → статический resolv.conf
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: отключение systemd-resolved ---"

if systemctl is-enabled systemd-resolved >/dev/null 2>&1 || \
   systemctl is-active  systemd-resolved >/dev/null 2>&1; then
  echo "[ИНФО] Отключаю systemd-resolved..."
  systemctl disable --now systemd-resolved || true
else
  echo "[ИНФО] systemd-resolved уже отключен."
fi

chattr -i /etc/resolv.conf 2>/dev/null || true
rm -f /etc/resolv.conf
cat >/etc/resolv.conf <<EOF
nameserver ${GW_IP}
search ${DOMAIN}
EOF
chattr +i /etc/resolv.conf
echo "[OK] /etc/resolv.conf защищён (immutable)."
cat /etc/resolv.conf

# ------------------------------------------------------------------
# ШАГ 5. Проверка связи
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: проверка связи ---"
ping -c3 "${GW_IP}"  && echo "[OK] ping ${GW_IP}" || echo "[ОШИБКА] нет связи с gateway."
ping -c3 ya.ru        && echo "[OK] ping ya.ru"    || echo "[ОШИБКА] нет выхода в интернет."

echo
echo "================================================================"
echo " Подготовка завершена. Теперь на ВМ gateway добавь"
echo " DNS-запись для ${MAIL_HOSTNAME} → запусти gateway_add_mail_dns.sh"
echo " Затем запусти mail_install_iredmail.sh на этой ВМ."
echo "================================================================"
