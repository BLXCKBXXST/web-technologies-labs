#!/usr/bin/env bash
# =============================================================
#  Практическая работа №7 — Часть 3
#  Добавление DNS-записи desktop1 в Samba DNS
#
#  Запускать: sudo bash gateway_lab7_dns.sh
#  ВМ: gateway (Ubuntu Server)
#  Запускать ПОСЛЕ того, как desktop1 получил IP
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №7 — DNS-записи для desktop1"
echo " Домен  : ${DOMAIN}"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. IP адрес desktop1 (задаётся вручную или через переменную)
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: ввод IP-адреса desktop1 ---"

if [[ -n "${DESKTOP_IP:-}" ]]; then
  echo "[ИНФО] IP из переменной окружения: ${DESKTOP_IP}"
else
  echo "[ИНФО] Можно задать IP заранее: DESKTOP_IP=192.168.${N}.10 bash $0"
  # Значение по умолчанию
  DESKTOP_IP="192.168.${N}.10"
  echo "[ИНФО] Используется значение по умолчанию: ${DESKTOP_IP}"
fi

# ------------------------------------------------------------------
# ШАГ 2. Добавление A-записи desktop1
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: добавление A-записи ${DESKTOP_HOSTNAME} → ${DESKTOP_IP} ---"

if samba-tool dns query "${SRV_IP}" "${DOMAIN}" \
     "${DESKTOP_HOSTNAME}" A \
     -U "Administrator%${ADMIN_PASS}" &>/dev/null; then
  echo "[ИНФО] Запись ${DESKTOP_HOSTNAME} уже существует — пересоздаю."
  samba-tool dns delete "${SRV_IP}" "${DOMAIN}" \
    "${DESKTOP_HOSTNAME}" A "${DESKTOP_IP}" \
    -U "Administrator%${ADMIN_PASS}" || true
fi

samba-tool dns add "${SRV_IP}" "${DOMAIN}" \
  "${DESKTOP_HOSTNAME}" A "${DESKTOP_IP}" \
  -U "Administrator%${ADMIN_PASS}"

echo "[OK] A-запись добавлена: ${DESKTOP_HOSTNAME}.${DOMAIN} → ${DESKTOP_IP}"

# ------------------------------------------------------------------
# ШАГ 3. Добавление PTR-записи
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: добавление PTR-записи (обратная зона) ---"

# Последний октет IP
OCTET="${DESKTOP_IP##*.}"
REVERSE_ZONE="${N}.168.192.in-addr.arpa"

samba-tool dns add "${SRV_IP}" "${REVERSE_ZONE}" \
  "${OCTET}" PTR "${DESKTOP_HOSTNAME}.${DOMAIN}." \
  -U "Administrator%${ADMIN_PASS}" 2>/dev/null || \
  echo "[ИНФО] PTR уже существует или обратная зона не настроена."

echo "[OK] PTR-запись: ${OCTET}.${REVERSE_ZONE} → ${DESKTOP_HOSTNAME}.${DOMAIN}"

# ------------------------------------------------------------------
# ШАГ 4. Проверка DNS
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: проверка DNS-записей ---"

echo "[ИНФО] nslookup ${DESKTOP_HOSTNAME}:"
nslookup "${DESKTOP_HOSTNAME}" "${SRV_IP}" || \
  echo "[ОШИБКА] nslookup не нашёл ${DESKTOP_HOSTNAME}."

echo
echo "================================================================"
echo " DNS готов. Теперь подключай desktop1 к домену:"
echo "   sudo bash desktop_lab7_join.sh"
echo "================================================================"
