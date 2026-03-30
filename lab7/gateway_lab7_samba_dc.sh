#!/usr/bin/env bash
# =============================================================
#  Практическая работа №7 — Часть 1
#  Установка и настройка Samba AD/DC на сервере gateway
#
#  Запускать: sudo bash gateway_lab7_samba_dc.sh
#  ВМ: gateway (Ubuntu Server)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №7 — Samba AD/DC на ${SERVER_HOSTNAME}"
echo " Домен  : ${DOMAIN_UPPER}"
echo " NetBIOS: ${NETBIOS_DOMAIN}"
echo " IP DC  : ${SRV_IP}"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Hostname и /etc/hosts
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: настройка hostname ---"
echo "[ИНФО] Текущий hostname: $(hostname)"
hostnamectl set-hostname "${SERVER_HOSTNAME}.${DOMAIN}"

cp /etc/hosts /etc/hosts.bak_lab7 2>/dev/null || true
echo "[РЕЗЕРВ] /etc/hosts.bak_lab7"

cat >/etc/hosts <<EOF
127.0.0.1   localhost
${SRV_IP}   ${SERVER_HOSTNAME}.${DOMAIN} ${SERVER_HOSTNAME}
EOF

echo "[OK] hostname = $(hostname)"

# ------------------------------------------------------------------
# ШАГ 2. Отключение systemd-resolved
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: отключение systemd-resolved ---"

if systemctl is-active systemd-resolved >/dev/null 2>&1; then
  systemctl disable --now systemd-resolved || true
  echo "[OK] systemd-resolved отключён."
else
  echo "[ИНФО] systemd-resolved уже был отключён."
fi

rm -f /etc/resolv.conf
cat >/etc/resolv.conf <<EOF
nameserver ${SRV_IP}
nameserver 8.8.8.8
search ${DOMAIN}
EOF
echo "[OK] /etc/resolv.conf прописан."

# ------------------------------------------------------------------
# ШАГ 3. Удаление bind9 (Samba использует встроенный DNS)
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: удаление bind9 (конфликтует с Samba DNS) ---"

if dpkg -l bind9 &>/dev/null; then
  systemctl stop bind9 2>/dev/null || true
  apt-get remove -y --purge bind9 bind9utils bind9-doc 2>/dev/null || true
  echo "[OK] bind9 удалён."
else
  echo "[ИНФО] bind9 не установлен — пропускаю."
fi

# ------------------------------------------------------------------
# ШАГ 4. Установка пакетов Samba AD
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: установка samba, krb5-user, winbind ---"
echo "[ИНФО] Это может занять несколько минут..."

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y \
  samba \
  krb5-user \
  winbind \
  libnss-winbind \
  libpam-winbind \
  smbclient \
  dnsutils

echo "[OK] Пакеты установлены: $(samba --version)"

# ------------------------------------------------------------------
# ШАГ 5. Резервная копия smb.conf и provisioning домена
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: provisioning Samba AD/DC ---"

SMB_CONF="/etc/samba/smb.conf"

if [[ -f "$SMB_CONF" ]]; then
  cp "$SMB_CONF" "${SMB_CONF}.bak_lab7"
  echo "[РЕЗЕРВ] ${SMB_CONF}.bak_lab7"
  rm -f "$SMB_CONF"
fi

# Удаляем старые базы Samba (если есть) перед provisioning
for f in /var/lib/samba/private/sam.ldb \
         /var/lib/samba/private/idmap.ldb \
         /var/lib/samba/private/secrets.ldb; do
  [[ -f "$f" ]] && rm -f "$f" && echo "[ИНФО] Удалён: $f"
done

samba-tool domain provision \
  --use-rfc2307 \
  --server-role=dc \
  --realm="${DOMAIN_UPPER}" \
  --domain="${NETBIOS_DOMAIN}" \
  --adminpass="${ADMIN_PASS}" \
  --dns-backend=SAMBA_INTERNAL

echo "[OK] Provisioning завершён."

# ------------------------------------------------------------------
# ШАГ 6. Настройка krb5.conf
# ------------------------------------------------------------------
echo
echo "--- Шаг 6: настройка /etc/krb5.conf ---"

KRB5_CONF="/etc/krb5.conf"
cp "$KRB5_CONF" "${KRB5_CONF}.bak_lab7" 2>/dev/null || true
echo "[РЕЗЕРВ] ${KRB5_CONF}.bak_lab7"

# Samba provisioning создаёт /var/lib/samba/private/krb5.conf
# Заменяем системный symlink
ln -sf /var/lib/samba/private/krb5.conf /etc/krb5.conf
echo "[OK] /etc/krb5.conf → /var/lib/samba/private/krb5.conf"

# ------------------------------------------------------------------
# ШАГ 7. Отключение служб Samba (кроме samba-ad-dc)
# ------------------------------------------------------------------
echo
echo "--- Шаг 7: включение samba-ad-dc, отключение nmbd/smbd ---"

for svc in smbd nmbd winbind; do
  systemctl disable "$svc" 2>/dev/null || true
  systemctl stop "$svc" 2>/dev/null || true
done

systemctl unmask samba-ad-dc
systemctl enable samba-ad-dc
systemctl start samba-ad-dc
sleep 3

if systemctl is-active samba-ad-dc >/dev/null 2>&1; then
  echo "[OK] samba-ad-dc запущен."
else
  echo "[ОШИБКА] samba-ad-dc не запустился. Проверьте: journalctl -xe -u samba-ad-dc"
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 8. Проверка AD
# ------------------------------------------------------------------
echo
echo "--- Шаг 8: проверка Samba AD ---"

echo "[ИНФО] Уровень домена:"
samba-tool domain level show || echo "[ОШИБКА] samba-tool domain level show провалился"

echo
echo "[ИНФО] DNS SRV-записи:"
host -t SRV _kerberos._udp."${DOMAIN}" "${SRV_IP}" || \
  echo "[ОШИБКА] SRV _kerberos не найден. Проверьте DNS Samba."

host -t SRV _ldap._tcp."${DOMAIN}" "${SRV_IP}" || \
  echo "[ОШИБКА] SRV _ldap не найден."

echo
echo "================================================================"
echo " Шаг 8 готов."
echo " Далее запусти: sudo bash gateway_lab7_shares.sh"
echo " Пароль администратора: ${ADMIN_PASS}"
echo "================================================================"
