#!/usr/bin/env bash
# =============================================================
#  Практическая работа №7 — Клиентская ВМ
#  Подключение Desktop к домену Samba AD
#
#  Запускать: sudo bash desktop_lab7_join.sh
#  ВМ: Desktop (Ubuntu Desktop)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №7 — Подключение к домену AD"
echo " Домен  : ${DOMAIN_UPPER}"
echo " DC     : ${SRV_IP} (${SERVER_HOSTNAME}.${DOMAIN})"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Hostname и /etc/hosts
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: установка hostname ---"
echo "[ИНФО] Старый hostname: $(hostname)"
hostnamectl set-hostname "${DESKTOP_HOSTNAME}.${DOMAIN}"

cp /etc/hosts /etc/hosts.bak_lab7 2>/dev/null || true
echo "[РЕЗЕРВ] /etc/hosts.bak_lab7"

cat >/etc/hosts <<EOF
127.0.0.1   localhost
127.0.1.1   ${DESKTOP_HOSTNAME}.${DOMAIN} ${DESKTOP_HOSTNAME}
EOF

echo "[OK] hostname = $(hostname)"

# ------------------------------------------------------------------
# ШАГ 2. Настройка resolv.conf — DNS указывает на DC
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: настройка resolv.conf (DNS → DC) ---"

if systemctl is-active systemd-resolved >/dev/null 2>&1; then
  systemctl disable --now systemd-resolved || true
  echo "[OK] systemd-resolved отключён."
fi

rm -f /etc/resolv.conf
cat >/etc/resolv.conf <<EOF
nameserver ${SRV_IP}
search ${DOMAIN}
EOF
echo "[OK] /etc/resolv.conf → nameserver ${SRV_IP}"

# ------------------------------------------------------------------
# ШАГ 3. Установка пакетов для присоединения к домену
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: установка realmd, sssd, samba-common ---"

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y \
  realmd \
  sssd \
  sssd-tools \
  libnss-sss \
  libpam-sss \
  samba-common \
  samba-common-bin \
  samba-libs \
  krb5-user \
  adcli \
  packagekit

echo "[OK] Пакеты установлены."

# ------------------------------------------------------------------
# ШАГ 4. Проверка доступности домена
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: проверка доступности домена ---"

if ping -c2 "${SRV_IP}" &>/dev/null; then
  echo "[OK] DC доступен по ping."
else
  echo "[ОШИБКА] DC ${SRV_IP} недоступен. Проверь сеть."
  exit 1
fi

if realm discover "${DOMAIN}" &>/dev/null; then
  echo "[OK] realm discover успешен — домен виден."
else
  echo "[ОШИБКА] realm discover провалился. Проверь DNS и samba-ad-dc на gateway."
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 5. Присоединение к домену (realm join)
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: присоединение к домену ---"
echo "[ИНФО] Используется Administrator / пароль из config.sh"

echo "${ADMIN_PASS}" | realm join -U Administrator "${DOMAIN}" --stdin-password

if realm list | grep -q "${DOMAIN}"; then
  echo "[OK] Присоединён к домену ${DOMAIN}."
else
  echo "[ОШИБКА] realm join провалился. Проверь: journalctl -xe"
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 6. Настройка SSSD — вход без указания домена
# ------------------------------------------------------------------
echo
echo "--- Шаг 6: настройка sssd.conf ---"

SSSD_CONF="/etc/sssd/sssd.conf"
if [[ -f "$SSSD_CONF" ]]; then
  cp "$SSSD_CONF" "${SSSD_CONF}.bak_lab7"
  echo "[РЕЗЕРВ] ${SSSD_CONF}.bak_lab7"
  sed -i 's/use_fully_qualified_names = True/use_fully_qualified_names = False/' "$SSSD_CONF"
  sed -i 's/fallback_homedir = .*/fallback_homedir = \/home\/%u/' "$SSSD_CONF"
  echo "[OK] sssd.conf обновлён (логин без @домена, homedir /home/<user>)."
fi

# ------------------------------------------------------------------
# ШАГ 7. Автосоздание домашних папок при входе
# ------------------------------------------------------------------
echo
echo "--- Шаг 7: pam_mkhomedir ---"

pam-auth-update --enable mkhomedir 2>/dev/null || \
  echo "[ИНФО] pam-auth-update не доступен — создай домашние папки вручную."

echo "[OK] mkhomedir включён."

# ------------------------------------------------------------------
# ШАГ 8. Перезапуск SSSD
# ------------------------------------------------------------------
echo
echo "--- Шаг 8: перезапуск sssd ---"
systemctl restart sssd
sleep 2

if systemctl is-active sssd >/dev/null 2>&1; then
  echo "[OK] sssd запущен."
else
  echo "[ОШИБКА] sssd не запустился. journalctl -xe -u sssd"
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 9. Проверка: getent passwd для domain users
# ------------------------------------------------------------------
echo
echo "--- Шаг 9: проверка пользователей домена ---"

echo "[ИНФО] id ${USER1_LOGIN}:"
id "${USER1_LOGIN}" 2>/dev/null || \
  echo "[ОШИБКА] Пользователь ${USER1_LOGIN} не найден — sssd не работает или пользователь не создан."

echo
echo "================================================================"
echo " Desktop присоединён к домену!"
echo
echo " [ИНТЕРАКТИВНЫЙ ШАГ] Подключение сетевой папки:"
echo
echo "   Вариант 1 — командная строка:"
echo "   sudo mount -t cifs \\\\\\\\${SRV_IP}\\\\${SHARE_PUBLIC} /mnt \\"
echo "       -o guest,vers=3.0"
echo
echo "   sudo mount -t cifs \\\\\\\\${SRV_IP}\\\\${SHARE_SECRET} /mnt \\"
echo "       -o username=${USER1_LOGIN},password=${USER1_PASS},vers=3.0"
echo
echo "   Вариант 2 — файловый менеджер Nautilus:"
echo "   Files → Другие места → Адрес сервера:"
echo "   smb://${SRV_IP}/${SHARE_PUBLIC}"
echo "   smb://${SRV_IP}/${SHARE_SECRET}"
echo
echo "   Вариант 3 — вход в систему как доменный пользователь:"
echo "   Выйди из текущей сессии → войди как ${USER1_LOGIN}"
echo "   (пароль: ${USER1_PASS})"
echo "================================================================"
