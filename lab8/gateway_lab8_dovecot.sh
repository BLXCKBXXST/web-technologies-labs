#!/usr/bin/env bash
# =============================================================
#  Практическая работа №8 — Часть 2
#  Настройка IMAP/POP3 сервера Dovecot на gateway
#
#  Запускать: sudo bash gateway_lab8_dovecot.sh
#  ВМ: gateway (Ubuntu Server)
#  Предварительно: запусти gateway_lab8_postfix.sh
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №8 — Dovecot (IMAP/POP3) на ${SERVER_HOSTNAME}"
echo " Домен  : ${DOMAIN}"
echo " Сеть   : 192.168.${N}.0/24"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Установка Dovecot
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: установка dovecot-imapd, dovecot-pop3d ---"
DEBIAN_FRONTEND=noninteractive apt-get install -y dovecot-imapd dovecot-pop3d
echo "[OK] Dovecot установлен: $(dovecot --version 2>&1 | head -1)"

# ------------------------------------------------------------------
# ШАГ 2. Настройка /etc/dovecot/dovecot.conf
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: настройка dovecot.conf (protocols) ---"
DOVECOT_CONF="/etc/dovecot/dovecot.conf"
cp "$DOVECOT_CONF" "${DOVECOT_CONF}${BAK_SUFFIX}"
echo "[РЕЗЕРВ] ${DOVECOT_CONF}${BAK_SUFFIX}"

# Устанавливаем протоколы
sed -i 's/^#\?protocols =.*/protocols = imap pop3/' "$DOVECOT_CONF"
grep -q '^protocols' "$DOVECOT_CONF" || echo "protocols = imap pop3" >> "$DOVECOT_CONF"
echo "[OK] dovecot.conf: protocols = imap pop3"

# ------------------------------------------------------------------
# ШАГ 3. Настройка /etc/dovecot/conf.d/10-mail.conf — Maildir
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: настройка хранилища почты (Maildir) ---"
MAIL_CONF="/etc/dovecot/conf.d/10-mail.conf"
cp "$MAIL_CONF" "${MAIL_CONF}${BAK_SUFFIX}"
echo "[РЕЗЕРВ] ${MAIL_CONF}${BAK_SUFFIX}"

sed -i 's|^#\?mail_location =.*|mail_location = maildir:~/Maildir|' "$MAIL_CONF"
echo "[OK] mail_location = maildir:~/Maildir"

# ------------------------------------------------------------------
# ШАГ 4. Настройка /etc/dovecot/conf.d/10-auth.conf — plain auth
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: настройка аутентификации ---"
AUTH_CONF="/etc/dovecot/conf.d/10-auth.conf"
cp "$AUTH_CONF" "${AUTH_CONF}${BAK_SUFFIX}"
echo "[РЕЗЕРВ] ${AUTH_CONF}${BAK_SUFFIX}"

# Разрешить plaintext auth (для лабораторной среды без TLS)
sed -i 's/^#\?disable_plaintext_auth =.*/disable_plaintext_auth = no/' "$AUTH_CONF"
echo "[OK] disable_plaintext_auth = no"

# ------------------------------------------------------------------
# ШАГ 5. Настройка /etc/dovecot/conf.d/10-master.conf — Postfix-интеграция
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: интеграция Dovecot с Postfix (SASL) ---"
MASTER_CONF="/etc/dovecot/conf.d/10-master.conf"
cp "$MASTER_CONF" "${MASTER_CONF}${BAK_SUFFIX}"
echo "[РЕЗЕРВ] ${MASTER_CONF}${BAK_SUFFIX}"

# Добавляем unix_listener для smtp-auth если ещё не прописан
if ! grep -q 'postfix/private/auth' "$MASTER_CONF"; then
  # Вставляем после строки с service auth {
  sed -i '/^service auth {/a\
  # Postfix smtp-auth\n  unix_listener /var/spool/postfix/private/auth {\n    mode = 0660\n    user = postfix\n    group = postfix\n  }' "$MASTER_CONF"
  echo "[OK] unix_listener /var/spool/postfix/private/auth добавлен."
else
  echo "[ИНФО] unix_listener уже настроен — пропускаю."
fi

# Включаем SASL в Postfix
postconf -e "smtpd_sasl_type = dovecot"
postconf -e "smtpd_sasl_path = private/auth"
postconf -e "smtpd_sasl_auth_enable = yes"
postconf -e "smtpd_recipient_restrictions = permit_sasl_authenticated, permit_mynetworks, reject_unauth_destination"
echo "[OK] Postfix SASL настроен."

# ------------------------------------------------------------------
# ШАГ 6. Открытие портов IMAP/POP3 в UFW
# ------------------------------------------------------------------
echo
echo "--- Шаг 6: разрешение портов IMAP/POP3 в UFW ---"
if command -v ufw >/dev/null 2>&1 && ufw status | grep -q 'Status: active'; then
  ufw allow 143/tcp
  ufw allow 110/tcp
  echo "[OK] UFW: порты 143 (IMAP) и 110 (POP3) открыты."
else
  echo "[ИНФО] UFW не активен — пропускаю."
fi

# ------------------------------------------------------------------
# ШАГ 7. Перезапуск Dovecot и Postfix + проверка
# ------------------------------------------------------------------
echo
echo "--- Шаг 7: перезапуск Dovecot и Postfix ---"
systemctl restart dovecot postfix
systemctl enable dovecot
sleep 2

echo "[ИНФО] Статус Dovecot:"
systemctl --no-pager --full status dovecot || true

echo
echo "[ИНФО] Dovecot слушает порты:"
ss -tlnp | grep -E ':143|:110|:25' || echo "[ОШИБКА] Проверь статус сервисов."

echo
echo "================================================================"
echo " Шаг 7 готов."
echo " Далее запусти: sudo bash gateway_lab8_users.sh"
echo "================================================================"
