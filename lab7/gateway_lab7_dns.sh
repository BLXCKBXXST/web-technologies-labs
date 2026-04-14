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
# ШАГ 0. Проверка и фикс named.conf.options (listen-on)
# ------------------------------------------------------------------
echo
echo "--- Шаг 0: проверка listen-on в named.conf.options ---"
NAMED_OPTIONS="/etc/bind/named.conf.options"

if ! grep -q '127\.0\.0\.1' "${NAMED_OPTIONS}"; then
  echo "[ИНФО] 127.0.0.1 отсутствует в listen-on — добавляю..."
  cp "${NAMED_OPTIONS}" "${NAMED_OPTIONS}.bak_lab7"
  cat > "${NAMED_OPTIONS}" <<EOF
options {
    directory "/var/cache/bind";

    forwarders {
        8.8.8.8;
    };

    dnssec-validation auto;

    auth-nxdomain no;
    listen-on {
        127.0.0.1;
        ${GW_IP};
    };
};
EOF
  echo "[OK] named.conf.options переписан, listen-on: 127.0.0.1 + ${GW_IP}"
else
  echo "[OK] 127.0.0.1 уже есть в listen-on — пропускаю."
fi

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
  # Запись есть — проверяем совпадает ли IP
  CURRENT_IP=$(grep "^mail[[:space:]]" "${FORWARD_DB}" | grep -oP '\d+\.\d+\.\d+\.\d+' | head -1)
  if [[ "${CURRENT_IP}" == "${MAIL_IP}" ]]; then
    echo "[OK] A-запись mail → ${MAIL_IP} уже верная — пропускаю."
  else
    echo "[ИНФО] A-запись mail существует с неверным IP (${CURRENT_IP}), заменяю на ${MAIL_IP}..."
    sed -i "/^mail[[:space:]]/d" "${FORWARD_DB}"
    update_serial "${FORWARD_DB}"
    echo "mail    IN  A  ${MAIL_IP}" >> "${FORWARD_DB}"
    echo "[OK] A-запись обновлена: mail → ${MAIL_IP}"
  fi
else
  update_serial "${FORWARD_DB}"
  echo "mail    IN  A  ${MAIL_IP}" >> "${FORWARD_DB}"
  echo "[OK] A-запись mail → ${MAIL_IP} добавлена"
fi

if ! grep -q "^@.*MX" "${FORWARD_DB}"; then
  echo "@       IN  MX  10  mail.${DOMAIN}." >> "${FORWARD_DB}"
  echo "[OK] MX-запись добавлена"
else
  echo "[OK] MX-запись уже есть — пропускаю."
fi

# ------------------------------------------------------------------
# ШАГ 3. Обратная зона DNS — PTR запись
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: обратная зона DNS — запись PTR ---"

LAST_OCTET="${MAIL_IP##*.}"

if grep -q "^${LAST_OCTET}[[:space:]]" "${REVERSE_DB}"; then
  # Запись есть — проверяем совпадает ли FQDN
  CURRENT_PTR=$(grep "^${LAST_OCTET}[[:space:]]" "${REVERSE_DB}" | awk '{print $NF}')
  EXPECTED_PTR="${MAIL_FQDN}."
  if [[ "${CURRENT_PTR}" == "${EXPECTED_PTR}" ]]; then
    echo "[OK] PTR-запись .${LAST_OCTET} уже верная — пропускаю."
  else
    echo "[ИНФО] PTR-запись .${LAST_OCTET} существует с неверным значением (${CURRENT_PTR}), заменяю..."
    sed -i "/^${LAST_OCTET}[[:space:]]/d" "${REVERSE_DB}"
    update_serial "${REVERSE_DB}"
    echo "${LAST_OCTET}    IN  PTR  ${MAIL_FQDN}." >> "${REVERSE_DB}"
    echo "[OK] PTR-запись обновлена: ${LAST_OCTET} → ${MAIL_FQDN}"
  fi
else
  update_serial "${REVERSE_DB}"
  echo "${LAST_OCTET}    IN  PTR  ${MAIL_FQDN}." >> "${REVERSE_DB}"
  echo "[OK] PTR-запись ${LAST_OCTET} → ${MAIL_FQDN} добавлена"
fi

# ------------------------------------------------------------------
# ШАГ 4. Стоп bind9 + удаление .jnl + старт
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: перезагрузка BIND9 (с очисткой .jnl) ---"

named-checkconf && echo "[OK] named-checkconf прошёл"
named-checkzone "${DOMAIN}" "${FORWARD_DB}" && echo "[OK] прямая зона валидна"
REVERSE_ZONE="${N}.168.192.in-addr.arpa"
named-checkzone "${REVERSE_ZONE}" "${REVERSE_DB}" && echo "[OK] обратная зона валидна"

systemctl stop bind9
rm -f "${FORWARD_DB}.jnl" "${REVERSE_DB}.jnl"
echo "[OK] .jnl-журналы удалены"
systemctl start bind9
sleep 5
echo "[OK] bind9 запущен"

# ------------------------------------------------------------------
# ШАГ 5. Проверка записей
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: проверка DNS ---"

RESOLVED=$(dig @127.0.0.1 "${MAIL_FQDN}" A +short 2>/dev/null | grep -oP '\d+\.\d+\.\d+\.\d+' | head -1)

if [[ "${RESOLVED}" == "${MAIL_IP}" ]]; then
  echo "[OK] DNS: ${MAIL_FQDN} → ${RESOLVED}"
else
  echo "[ОШИБКА] dig @127.0.0.1 ${MAIL_FQDN} вернул: '${RESOLVED}', ожидался: '${MAIL_IP}'" >&2
  exit 1
fi

MX_RESULT=$(dig @127.0.0.1 "${DOMAIN}" MX +short 2>/dev/null)
echo "[OK] MX: ${MX_RESULT}"

PTR_RESULT=$(dig @127.0.0.1 -x "${MAIL_IP}" +short 2>/dev/null)
echo "[OK] PTR: ${MAIL_IP} → ${PTR_RESULT}"

echo
echo "================================================================"
echo " [ГОТОВО] DNS-записи для mail добавлены."
echo " Следующий шаг: запусти mail_lab7_prepare.sh на ВМ mail"
echo "================================================================"
