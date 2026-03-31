#!/usr/bin/env bash
# =============================================================
#  Практическая работа №5 — Клиентская ВМ
#  Подготовка Desktop: hostname + подсказки по настройке сети
#
#  Запускать: sudo bash desktop_lab5_prepare.sh
#  ВМ: Desktop (Ubuntu Desktop)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №5 — Подготовка клиентской ВМ"
echo " Hostname : ${DESKTOP_HOSTNAME}"
echo " Домен    : ${DOMAIN}"
echo " DNS/GW   : 192.168.${N}.1"
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
# ШАГ 2. Отключение systemd-resolved → фиксированный resolv.conf
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: отключение systemd-resolved ---"

if systemctl is-enabled systemd-resolved >/dev/null 2>&1 || \
   systemctl is-active  systemd-resolved >/dev/null 2>&1; then
  echo "[ИНФО] Отключаю systemd-resolved..."
  systemctl disable --now systemd-resolved || true
else
  echo "[ИНФО] systemd-resolved уже отключен."
fi

# Снять immutable-флаг если был выставлен ранее
chattr -i /etc/resolv.conf 2>/dev/null || true
rm -f /etc/resolv.conf

cat >/etc/resolv.conf <<EOF
nameserver 192.168.${N}.1
search ${DOMAIN}
EOF

# Защитить от перезаписи NetworkManager
chattr +i /etc/resolv.conf
echo "[OK] /etc/resolv.conf защищён (immutable), содержимое:"
cat /etc/resolv.conf

# ------------------------------------------------------------------
# ШАГ 3. Подсказки по настройке сети в GUI
# ------------------------------------------------------------------
echo
echo "================================================================"
echo " [ИНТЕРАКТИВНЫЙ ШАГ] Настрой сетевой интерфейс в GUI:"
echo
echo " Settings → Network → Wired → шестерёнка"
echo
echo " Вариант А — статический IP (до включения DHCP):"
echo "   IPv4 Method : Manual"
echo "   Address     : 192.168.${N}.10"
echo "   Netmask     : 255.255.255.0"
echo "   Gateway     : 192.168.${N}.1"
echo "   DNS         : 192.168.${N}.1"
echo
echo " Вариант Б — после включения DHCP+DDNS на gateway:"
echo "   IPv4 Method : Automatic (DHCP)"
echo
echo " После применения настроек проверь в терминале:"
echo "   ping 192.168.${N}.1"
echo "   ping ya.ru"
echo "   nslookup gateway"
echo "   nslookup ${DESKTOP_HOSTNAME}"
echo "================================================================"
