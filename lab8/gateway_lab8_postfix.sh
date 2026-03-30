#!/usr/bin/env bash
# =============================================================
#  Практическая работа №8 — Часть 1
#  Настройка почтового сервера Postfix (SMTP) на gateway
#
#  Запускать: sudo bash gateway_lab8_postfix.sh
#  ВМ: gateway (Ubuntu Server)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №8 — Postfix (SMTP) на ${SERVER_HOSTNAME}"
echo " Домен  : ${DOMAIN}"
echo " FQDN   : ${MAIL_FQDN}"
echo " Сеть   : 192.168.${N}.0/24"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Обновление hostname до FQDN
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: установка FQDN hostname ---"
echo "[ИНФО] Текущий hostname: $(hostname)"
hostnamectl set-hostname "${MAIL_FQDN}"

cat >/etc/hosts <<EOF
127.0.0.1   localhost
127.0.1.1   ${MAIL_FQDN} ${SERVER_HOSTNAME}
192.168.${N}.1   ${MAIL_FQDN} ${SERVER_HOSTNAME}
EOF

echo "[OK] hostname = $(hostname --fqdn)"

# ------------------------------------------------------------------
# ШАГ 2. Установка Postfix и вспомогательных пакетов
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: установка Postfix, mailutils ---"

# Предустановка debconf, чтобы избежать интерактивного меню
echo "postfix postfix/mailname string ${MAIL_FQDN}" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

DEBIAN_FRONTEND=noninteractive apt-get install -y postfix mailutils
echo "[OK] Postfix установлен: $(postconf mail_version)"

# ------------------------------------------------------------------
# ШАГ 3. Настройка /etc/postfix/main.cf
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: настройка main.cf ---"
MAIN_CF="/etc/postfix/main.cf"
cp "$MAIN_CF" "${MAIN_CF}${BAK_SUFFIX}"
echo "[РЕЗЕРВ] ${MAIN_CF}${BAK_SUFFIX}"

postconf -e "myhostname = ${MAIL_FQDN}"
postconf -e "mydomain = ${DOMAIN}"
postconf -e "myorigin = \$mydomain"
postconf -e "inet_interfaces = all"
postconf -e "inet_protocols = ipv4"
postconf -e "mydestination = \$myhostname, localhost.\$mydomain, localhost, \$mydomain"
postconf -e "mynetworks = 127.0.0.0/8, 192.168.${N}.0/24"
postconf -e "home_mailbox = Maildir/"
postconf -e "smtpd_banner = \$myhostname ESMTP"
postconf -e "disable_vrfy_command = yes"
postconf -e "smtpd_helo_required = yes"

echo "[OK] main.cf обновлён."

# ------------------------------------------------------------------
# ШАГ 4. Открытие порта 25 в UFW (если включён)
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: разрешение SMTP (порт 25) в UFW ---"
if command -v ufw >/dev/null 2>&1 && ufw status | grep -q 'Status: active'; then
  ufw allow 25/tcp
  echo "[OK] UFW: порт 25/tcp открыт."
else
  echo "[ИНФО] UFW не активен — пропускаю."
fi

# ------------------------------------------------------------------
# ШАГ 5. Перезапуск Postfix + проверка
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: перезапуск Postfix и проверка ---"
systemctl restart postfix
systemctl enable postfix
sleep 2

echo "[ИНФО] Статус Postfix:"
systemctl --no-pager --full status postfix || true

echo
echo "[ИНФО] Postfix слушает на порту 25:"
ss -tlnp | grep ':25' || echo "[ОШИБКА] Postfix не слушает порт 25"

echo
echo "================================================================"
echo " Шаг 5 готов."
echo " Далее запусти: sudo bash gateway_lab8_dovecot.sh"
echo "================================================================"
