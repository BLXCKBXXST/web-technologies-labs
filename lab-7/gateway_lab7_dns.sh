#!/usr/bin/env bash
# =============================================================
#  Практическая работа №7 — Электронная почта
#  Добавление DNS-записей для mail-сервера (ВМ: gateway)
#
#  Запускать: sudo bash gateway_lab7_dns.sh
#  ВМ: gateway (192.168.N.1)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №7 — Добавление DNS-записей для mail"
echo " Домен    : ${DOMAIN}"
echo " Mail IP  : ${MAIL_IP}"
echo " Gateway  : ${GW_IP}"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# Вспомогательная функция: обновить Serial в файле зоны
# Поддерживает серийники любой длины (8, 9, 10 цифр и т.д.)
# ------------------------------------------------------------------
update_serial() {
  local zonefile="$1"
  local SERIAL_OLD
  SERIAL_OLD=$(grep -oP '[0-9]{7,}' "${zonefile}" | head -1)
  if [[ -n "${SERIAL_OLD}" ]]; then
    local SERIAL_NEW=$(( SERIAL_OLD + 1 ))
    sed -i "s/${SERIAL_OLD}/${SERIAL_NEW}/" "${zonefile}"
    echo "[ИНФО] Serial обновлён: ${SERIAL_OLD} → ${SERIAL_NEW}"
  else
    echo "[ПРЕДУПРЕЖДЕНИЕ] Serial не найден в ${zonefile}, пропускаю обновление."
  fi
}

# ------------------------------------------------------------------
# ШАГ 1. Резервная копия зон BIND
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: резервные копии файлов зон ---"

for f in "${FORWARD_DB}" "${REVERSE_DB}"; do
  if [[ -f "${f}" ]]; then
    BAK="${f}.bak_lab7"
    cp "${f}" "${BAK}"
    echo "[РЕЗЕРВ] ${f} → ${BAK}"
  else
    echo "[ОШИБКА] Файл зоны не найден: ${f}" >&2
    exit 1
  fi
done

# ------------------------------------------------------------------
# ШАГ 2. Прямая зона DNS — A и MX записи
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: прямая зона DNS — запись A для mail ---"

if grep -q "^mail[[:space:]]" "${FORWARD_DB}"; then
  echo "[ИНФО] Запись 'mail' уже существует в прямой зоне. Пропускаю."
else
  update_serial "${FORWARD_DB}"

  echo "mail    IN  A  ${MAIL_IP}" >> "${FORWARD_DB}"
  echo "[OK] A-запись mail → ${MAIL_IP} добавлена"

  if ! grep -q "^@.*MX" "${FORWARD_DB}"; then
    echo "@       IN  MX  10  mail.${DOMAIN}." >> "${FORWARD_DB}"
    echo "[OK] MX-запись добавлена"
  fi
fi

# ------------------------------------------------------------------
# ШАГ 3. Обратная зона DNS — PTR запись
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: обратная зона DNS — запись PTR ---"

LAST_OCTET="${MAIL_IP##*.}"

if grep -q "^${LAST_OCTET}[[:space:]]" "${REVERSE_DB}"; then
  echo "[ИНФО] PTR-запись для .${LAST_OCTET} уже существует. Пропускаю."
else
  update_serial "${REVERSE_DB}"
  echo "${LAST_OCTET}    IN  PTR  ${MAIL_FQDN}." >> "${REVERSE_DB}"
  echo "[OK] PTR-запись ${LAST_OCTET} → ${MAIL_FQDN} добавлена"
fi

# ------------------------------------------------------------------
# ШАГ 4. Перезагрузка BIND и проверка
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: перезагрузка BIND9 ---"

named-checkconf && echo "[OK] named-checkconf прошёл"
named-checkzone "${DOMAIN}" "${FORWARD_DB}" && echo "[OK] прямая зона валидна"
REVERSE_ZONE="${N}.168.192.in-addr.arpa"
named-checkzone "${REVERSE_ZONE}" "${REVERSE_DB}" && echo "[OK] обратная зона валидна"

# restart надёжнее reload при первом добавлении зон
 systemctl restart bind9
sleep 5
echo "[OK] bind9 перезагружен"

# ------------------------------------------------------------------
# ШАГ 5. Проверка записей
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: проверка DNS ---"

if host "${MAIL_FQDN}" 127.0.0.1 >/dev/null 2>&1; then
  RESOLVED=$(host "${MAIL_FQDN}" 127.0.0.1 | grep -oP '\d+\.\d+\.\d+\.\d+' | head -1)
  if [[ "${RESOLVED}" == "${MAIL_IP}" ]]; then
    echo "[OK] DNS: ${MAIL_FQDN} → ${RESOLVED}"
  else
    echo "[ОШИБКА] DNS вернул ${RESOLVED}, ожидался ${MAIL_IP}" >&2
    exit 1
  fi
else
  echo "[ОШИБКА] Не удалось разрешить ${MAIL_FQDN}" >&2
  exit 1
fi

echo
echo "================================================================"
echo " [ГОТОВО] DNS-записи для mail добавлены."
echo " Следующий шаг: запусти mail_lab7_prepare.sh на ВМ mail"
echo "================================================================"
