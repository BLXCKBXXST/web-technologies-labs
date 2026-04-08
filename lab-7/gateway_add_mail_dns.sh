#!/usr/bin/env bash
# =============================================================
#  Практическая работа №7 — Добавление DNS-записи для mail
#  Добавляет A-запись mail → 192.168.N.5 в forward.db
#
#  Запускать: sudo bash gateway_add_mail_dns.sh
#  ВМ: gateway (Ubuntu Server)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №7 — DNS на gateway: добавить mail"
echo " Запись : ${MAIL_HOSTNAME} IN A ${MAIL_IP}"
echo " Файл   : ${FORWARD_DB}"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Проверить что forward.db существует
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: проверка ${FORWARD_DB} ---"

if [[ ! -f "${FORWARD_DB}" ]]; then
  echo "[ОШИБКА] Файл ${FORWARD_DB} не найден."
  echo "[ИНФО]  Сначала выполни лаб.5 (gateway_lab5.sh)."
  exit 1
fi

echo "[OK] ${FORWARD_DB} существует."

# ------------------------------------------------------------------
# ШАГ 2. Проверить — нет ли уже такой записи
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: проверка дублирования ---"

if grep -q "^${MAIL_HOSTNAME}[[:space:]]" "${FORWARD_DB}" 2>/dev/null; then
  echo "[ИНФО] Запись для '${MAIL_HOSTNAME}' уже есть в ${FORWARD_DB} — пропускаю добавление."
else
  # Резерв
  cp "${FORWARD_DB}" "${FORWARD_DB}.bak_lab7"
  echo "[РЕЗЕРВ] ${FORWARD_DB}.bak_lab7"

  # Добавить A-запись в конец файла
  echo "${MAIL_HOSTNAME}    IN      A       ${MAIL_IP}" >> "${FORWARD_DB}"
  echo "[OK] A-запись добавлена: ${MAIL_HOSTNAME} → ${MAIL_IP}"
fi

# ------------------------------------------------------------------
# ШАГ 3. Добавить PTR в reverse.db
# ------------------------------------------------------------------
REVERSE_DB="/var/lib/bind/reverse.db"
echo
echo "--- Шаг 3: PTR-запись в ${REVERSE_DB} ---"

# Последний октет IP
LAST_OCTET="${MAIL_IP##*.}"

if [[ -f "${REVERSE_DB}" ]]; then
  if grep -q "^${LAST_OCTET}[[:space:]]" "${REVERSE_DB}" 2>/dev/null; then
    echo "[ИНФО] PTR для '${LAST_OCTET}' уже есть — пропускаю."
  else
    cp "${REVERSE_DB}" "${REVERSE_DB}.bak_lab7"
    echo "[РЕЗЕРВ] ${REVERSE_DB}.bak_lab7"
    echo "${LAST_OCTET}    IN      PTR     ${MAIL_FQDN}." >> "${REVERSE_DB}"
    echo "[OK] PTR-запись добавлена: ${LAST_OCTET} → ${MAIL_FQDN}"
  fi
else
  echo "[ПРЕДУПРЕЖДЕНИЕ] ${REVERSE_DB} не найден — PTR-запись не добавлена."
fi

# ------------------------------------------------------------------
# ШАГ 4. Перезапуск bind9 + проверка
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: перезапуск bind9 ---"
systemctl restart bind9
sleep 2

echo "[ИНФО] Статус bind9:"
systemctl --no-pager --full status bind9 || true

echo
echo "[ИНФО] nslookup ${MAIL_HOSTNAME}:"
nslookup "${MAIL_HOSTNAME}" || echo "[ОШИБКА] nslookup провалился — проверь синтаксис forward.db"

echo
echo "[ИНФО] Обратный nslookup ${MAIL_IP}:"
nslookup "${MAIL_IP}" || echo "[ОШИБКА] Обратный nslookup провалился."

echo
echo "================================================================"
echo " DNS для mail настроен. Переходи на ВМ mail"
echo " и запускай: sudo bash mail_install_iredmail.sh"
echo "================================================================"
