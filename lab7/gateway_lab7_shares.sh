#!/usr/bin/env bash
# =============================================================
#  Практическая работа №7 — Часть 2
#  Создание общих папок (шаров) и тестовых пользователей
#
#  Запускать: sudo bash gateway_lab7_shares.sh
#  ВМ: gateway (Ubuntu Server)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №7 — Шары и пользователи на ${SERVER_HOSTNAME}"
echo " Домен  : ${DOMAIN_UPPER}"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Создание директорий для общих папок
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: создание директорий шаров ---"

mkdir -p "$SHARE_PUBLIC_PATH" "$SHARE_SECRET_PATH"
chmod 0777 "$SHARE_PUBLIC_PATH"
chmod 0770 "$SHARE_SECRET_PATH"

echo "[OK] ${SHARE_PUBLIC_PATH} (777)"
echo "[OK] ${SHARE_SECRET_PATH} (770)"

# ------------------------------------------------------------------
# ШАГ 2. Добавление шаров в smb.conf
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: настройка smb.conf (добавление шаров) ---"

SMB_CONF="/etc/samba/smb.conf"
cp "$SMB_CONF" "${SMB_CONF}.bak_lab7_shares" 2>/dev/null || true
echo "[РЕЗЕРВ] ${SMB_CONF}.bak_lab7_shares"

# Удаляем старые секции public/secret, если есть
sed -i "/^\[${SHARE_PUBLIC}\]/,/^\[/{ /^\[${SHARE_PUBLIC}\]/d; /^\[/!d }" "$SMB_CONF" 2>/dev/null || true
sed -i "/^\[${SHARE_SECRET}\]/,/^\[/{ /^\[${SHARE_SECRET}\]/d; /^\[/!d }" "$SMB_CONF" 2>/dev/null || true

cat >>"$SMB_CONF" <<EOF

[${SHARE_PUBLIC}]
   path = ${SHARE_PUBLIC_PATH}
   read only = no
   guest ok = yes
   comment = Общая папка (без ограничений)

[${SHARE_SECRET}]
   path = ${SHARE_SECRET_PATH}
   read only = no
   guest ok = no
   valid users = @"Domain Users"
   comment = Папка только для пользователей домена
EOF

echo "[OK] Шары добавлены в smb.conf."

# Проверяем синтаксис smb.conf
testparm -s /dev/null 2>&1 | head -5 || true

# ------------------------------------------------------------------
# ШАГ 3. Создание тестовых пользователей в AD
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: создание пользователей AD ---"

for login in "$USER1_LOGIN" "$USER2_LOGIN"; do
  pass_var="${login^^}_PASS"
  pass="${!pass_var}"

  if samba-tool user show "$login" &>/dev/null; then
    echo "[ИНФО] Пользователь '$login' уже существует — пропускаю."
  else
    samba-tool user create "$login" "$pass" \
      --given-name="$login" \
      --surname="Test"
    echo "[OK] Пользователь '$login' создан."
  fi
done

echo
echo "[ИНФО] Список пользователей домена:"
samba-tool user list

# ------------------------------------------------------------------
# ШАГ 4. Перезапуск Samba AD
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: перезапуск samba-ad-dc ---"
systemctl restart samba-ad-dc
sleep 3

if systemctl is-active samba-ad-dc >/dev/null 2>&1; then
  echo "[OK] samba-ad-dc перезапущен."
else
  echo "[ОШИБКА] samba-ad-dc не запустился. journalctl -xe -u samba-ad-dc"
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 5. Проверка шаров
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: проверка шаров ---"

echo "[ИНФО] Список шаров через smbclient:"
smbclient -L //localhost -U "Administrator%${ADMIN_PASS}" 2>/dev/null || \
  echo "[ОШИБКА] smbclient не смог получить список. Проверь samba-ad-dc."

echo
echo "================================================================"
echo " Шары готовы:"
echo "   \\\\${SRV_IP}\\${SHARE_PUBLIC}  — гостевой доступ"
echo "   \\\\${SRV_IP}\\${SHARE_SECRET}  — только domain users"
echo
echo " Далее подключи Desktop к домену:"
echo "   sudo bash desktop_lab7_join.sh"
echo "================================================================"
