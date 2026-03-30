#!/usr/bin/env bash
# =============================================================
#  Практическая работа №8 — Часть 3
#  Создание почтовых пользователей и проверка отправки почты
#
#  Запускать: sudo bash gateway_lab8_users.sh
#  ВМ: gateway (Ubuntu Server)
#  Предварительно: запусти gateway_lab8_dovecot.sh
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №8 — Почтовые пользователи на ${SERVER_HOSTNAME}"
echo " Пользователи: ${MAIL_USER1}, ${MAIL_USER2}"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Создание системных пользователей
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: создание пользователей ${MAIL_USER1}, ${MAIL_USER2} ---"

for USER in "${MAIL_USER1}" "${MAIL_USER2}"; do
  if id "$USER" &>/dev/null; then
    echo "[ИНФО] Пользователь $USER уже существует — пропускаю создание."
  else
    useradd -m -s /bin/bash "$USER"
    echo "[OK] Пользователь $USER создан."
  fi
done

# Устанавливаем пароли
echo "${MAIL_USER1}:${MAIL_USER1_PASS}" | chpasswd
echo "${MAIL_USER2}:${MAIL_USER2_PASS}" | chpasswd
echo "[OK] Пароли установлены."

# ------------------------------------------------------------------
# ШАГ 2. Создание структуры Maildir
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: создание Maildir для каждого пользователя ---"

for USER in "${MAIL_USER1}" "${MAIL_USER2}"; do
  HOMEDIR=$(getent passwd "$USER" | cut -d: -f6)
  maildirmake.dovecot "${HOMEDIR}/Maildir" 2>/dev/null || mkdir -p "${HOMEDIR}/Maildir/{cur,new,tmp}"
  chown -R "${USER}:${USER}" "${HOMEDIR}/Maildir"
  echo "[OK] Maildir создан: ${HOMEDIR}/Maildir"
done

# ------------------------------------------------------------------
# ШАГ 3. Добавление DNS MX-записи для домена
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: добавление MX-записи в forward.db ---"
FWD_DB="/var/lib/bind/forward.db"

if [[ -f "$FWD_DB" ]]; then
  cp "$FWD_DB" "${FWD_DB}${BAK_SUFFIX}"
  echo "[РЕЗЕРВ] ${FWD_DB}${BAK_SUFFIX}"

  # Проверяем, нет ли уже MX-записи
  if ! grep -q 'MX' "$FWD_DB"; then
    # Добавляем MX-запись и A-запись mail после строки с NS
    sed -i "/IN.*NS.*${SERVER_HOSTNAME}/a\\            IN      MX 10   mail.${DOMAIN}.\\nmail      IN      A       192.168.${N}.1" "$FWD_DB"
    echo "[OK] MX-запись добавлена в forward.db."
  else
    echo "[ИНФО] MX-запись уже существует — пропускаю."
  fi

  # Обновляем serial (инкремент)
  SERIAL=$(grep 'Serial' "$FWD_DB" | awk '{print $1}')
  NEW_SERIAL=$(( SERIAL + 1 ))
  sed -i "s/${SERIAL}.*; Serial/${NEW_SERIAL}         ; Serial/" "$FWD_DB"

  rndc reload 2>/dev/null && echo "[OK] bind9 зоны перезагружены (rndc reload)." || \
    systemctl restart bind9 && echo "[OK] bind9 перезапущен."
else
  echo "[ИНФО] ${FWD_DB} не найден (bind9 не из лаб.5). Пропускаю MX."
fi

# ------------------------------------------------------------------
# ШАГ 4. Тестовая отправка письма
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: тестовая отправка письма ---"
echo "Тест отправки с сервера лаб.8" | \
  mail -s "Test lab8" -r "${MAIL_USER1}@${DOMAIN}" "${MAIL_USER2}@${DOMAIN}" || \
  echo "[ОШИБКА] Не удалось отправить тест. Проверь: systemctl status postfix"

sleep 2

HOME2=$(getent passwd "${MAIL_USER2}" | cut -d: -f6)
NEW_COUNT=$(find "${HOME2}/Maildir/new" -type f 2>/dev/null | wc -l)

if [[ "$NEW_COUNT" -gt 0 ]]; then
  echo "[OK] Письмо доставлено: ${NEW_COUNT} новых сообщений в Maildir ${MAIL_USER2}."
else
  echo "[ОШИБКА] Письмо не найдено в Maildir/${MAIL_USER2}/new. Смотри: tail -40 /var/log/mail.log"
fi

# ------------------------------------------------------------------
# ШАГ 5. Вывод итоговой информации для проверки
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: итоговая проверка сервисов ---"
for SVC in postfix dovecot; do
  STATUS=$(systemctl is-active "$SVC" 2>/dev/null || echo 'inactive')
  if [[ "$STATUS" == 'active' ]]; then
    echo "[OK] ${SVC}: active"
  else
    echo "[ОШИБКА] ${SVC}: ${STATUS}"
  fi
done

echo
echo "[ИНФО] Открытые почтовые порты:"
ss -tlnp | grep -E ':25|:110|:143' || echo "[ОШИБКА] Нет слушающих портов"

echo
echo "================================================================"
echo " Пользователи созданы, тест отправлен."
echo " На Desktop запусти: sudo bash desktop_lab8_client.sh"
echo "================================================================"
