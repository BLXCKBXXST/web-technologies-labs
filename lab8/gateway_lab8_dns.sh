#!/usr/bin/env bash
# =============================================================
#  Практическая работа №8 — WordPress
#  Добавление DNS-записи для wordpress-сервера (ВМ: gateway)
#
#  Запускать: sudo bash gateway_lab8_dns.sh
#  ВМ: gateway (192.168.N.1)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №8 — Добавление DNS-записи для wordpress"
echo " Домен    : ${DOMAIN}"
echo " WP IP    : ${WP_IP}"
echo " Gateway  : ${GW_IP}"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# Вспомогательная функция: обновить Serial
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
    echo "[ПРЕДУПРЕЖДЕНИЕ] Serial не найден в ${zonefile}"
  fi
}

# ------------------------------------------------------------------
# ШАГ 1. Резервные копии файлов зон
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: резервные копии файлов зон ---"
for f in "${FORWARD_DB}" "${REVERSE_DB}"; do
  if [[ -f "${f}" ]]; then
    BAK="${f}.bak_lab8"
    cp "${f}" "${BAK}"
    echo "[РЕЗЕРВ] ${f} → ${BAK}"
  else
    echo "[ОШИБКА] Файл зоны не найден: ${f}" >&2
    exit 1
  fi
done

# ------------------------------------------------------------------
# ШАГ 2. A-запись для wordpress
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: прямая зона — A-запись для wordpress ---"

if grep -q "^${WP_HOSTNAME}[[:space:]]" "${FORWARD_DB}"; then
  CURRENT_IP=$(grep "^${WP_HOSTNAME}[[:space:]]" "${FORWARD_DB}" | grep -oP '\d+\.\d+\.\d+\.\d+' | head -1)
  if [[ "${CURRENT_IP}" == "${WP_IP}" ]]; then
    echo "[OK] A-запись ${WP_HOSTNAME} → ${WP_IP} уже верная — пропускаю."
  else
    echo "[ИНФО] A-запись ${WP_HOSTNAME} существует с неверным IP (${CURRENT_IP}), заменяю..."
    sed -i "/^${WP_HOSTNAME}[[:space:]]/d" "${FORWARD_DB}"
    update_serial "${FORWARD_DB}"
    echo "${WP_HOSTNAME}    IN  A  ${WP_IP}" >> "${FORWARD_DB}"
    echo "[OK] A-запись обновлена: ${WP_HOSTNAME} → ${WP_IP}"
  fi
else
  update_serial "${FORWARD_DB}"
  echo "${WP_HOSTNAME}    IN  A  ${WP_IP}" >> "${FORWARD_DB}"
  echo "[OK] A-запись добавлена: ${WP_HOSTNAME} → ${WP_IP}"
fi

# ------------------------------------------------------------------
# ШАГ 3. PTR-запись
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: обратная зона — PTR-запись для wordpress ---"

LAST_OCTET="${WP_IP##*.}"
if grep -q "^${LAST_OCTET}[[:space:]]" "${REVERSE_DB}"; then
  CURRENT_PTR=$(grep "^${LAST_OCTET}[[:space:]]" "${REVERSE_DB}" | awk '{print $NF}')
  EXPECTED_PTR="${WP_FQDN}."
  if [[ "${CURRENT_PTR}" == "${EXPECTED_PTR}" ]]; then
    echo "[OK] PTR-запись .${LAST_OCTET} уже верная — пропускаю."
  else
    echo "[ИНФО] PTR-запись .${LAST_OCTET} неверная (${CURRENT_PTR}), заменяю..."
    sed -i "/^${LAST_OCTET}[[:space:]]/d" "${REVERSE_DB}"
    update_serial "${REVERSE_DB}"
    echo "${LAST_OCTET}    IN  PTR  ${WP_FQDN}." >> "${REVERSE_DB}"
    echo "[OK] PTR-запись обновлена: ${LAST_OCTET} → ${WP_FQDN}"
  fi
else
  update_serial "${REVERSE_DB}"
  echo "${LAST_OCTET}    IN  PTR  ${WP_FQDN}." >> "${REVERSE_DB}"
  echo "[OK] PTR-запись добавлена: ${LAST_OCTET} → ${WP_FQDN}"
fi

# ------------------------------------------------------------------
# ШАГ 4. Перезагрузка BIND9
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: перезагрузка BIND9 ---"

named-checkconf && echo "[OK] named-checkconf прошёл"
named-checkzone "${DOMAIN}" "${FORWARD_DB}" && echo "[OK] прямая зона валидна"
REVERSE_ZONE="${N}.168.192.in-addr.arpa"
named-checkzone "${REVERSE_ZONE}" "${REVERSE_DB}" && echo "[OK] обратная зона валидна"

systemctl stop bind9
rm -f "${FORWARD_DB}.jnl" "${REVERSE_DB}.jnl"
echo "[OK] .jnl-журналы удалены"
systemctl start bind9
sleep 3
echo "[OK] bind9 запущен"

# ------------------------------------------------------------------
# ШАГ 5. Проверка DNS
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: проверка DNS ---"

RESOLVED=$(dig @127.0.0.1 "${WP_FQDN}" A +short 2>/dev/null | grep -oP '\d+\.\d+\.\d+\.\d+' | head -1)
if [[ "${RESOLVED}" == "${WP_IP}" ]]; then
  echo "[OK] DNS: ${WP_FQDN} → ${RESOLVED}"
else
  echo "[ОШИБКА] dig @127.0.0.1 ${WP_FQDN} вернул: '${RESOLVED}', ожидался: '${WP_IP}'" >&2
  exit 1
fi

PTR_RESULT=$(dig @127.0.0.1 -x "${WP_IP}" +short 2>/dev/null)
echo "[OK] PTR: ${WP_IP} → ${PTR_RESULT}"

echo
echo "================================================================"
echo " [ГОТОВО] DNS-запись для wordpress добавлена."
echo " Следующий шаг: запусти wordpress_lab8_prepare.sh на ВМ wordpress"
echo "================================================================"
