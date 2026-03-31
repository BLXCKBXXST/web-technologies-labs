#!/usr/bin/env bash
# =============================================================
#  Практическая работа №6 — DNS-запись на gateway
#
#  Запускать: sudo bash gateway_lab6_dns.sh
#  ВМ: gateway (Ubuntu Server) — тот же сервер из лаб.4/5
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №6 — добавление DNS-записи для ${SEAFILE_HOSTNAME}"
echo " Домен   : ${DOMAIN}"
echo " Запись  : ${SEAFILE_HOSTNAME} -> ${SEAFILE_IP}"
echo " forward.db: ${FORWARD_DB}"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

if [[ ! -f "${FORWARD_DB}" ]]; then
  echo "[ОШИБКА] Файл ${FORWARD_DB} не найден."
  echo "         Убедись, что лаб.5 выполнена и bind9 настроен."
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Добавление / обновление A-записи в forward.db
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: проверка/обновление A-записи для ${SEAFILE_HOSTNAME} ---"

if grep -qE "^${SEAFILE_HOSTNAME}[[:space:]]" "${FORWARD_DB}"; then
  # Запись есть — проверяем совпадает ли IP
  EXISTING_IP=$(grep -E "^${SEAFILE_HOSTNAME}[[:space:]]" "${FORWARD_DB}" | awk '{print $NF}')
  if [[ "${EXISTING_IP}" == "${SEAFILE_IP}" ]]; then
    echo "[OK] Запись ${SEAFILE_HOSTNAME} IN A ${SEAFILE_IP} уже актуальна — пропускаю."
  else
    echo "[ИНФО] Найдена устаревшая запись: ${SEAFILE_HOSTNAME} -> ${EXISTING_IP}"
    echo "[ИНФО] Обновляю на: ${SEAFILE_HOSTNAME} -> ${SEAFILE_IP}"
    # Удаляем старую запись и добавляем новую
    sed -i "/^${SEAFILE_HOSTNAME}[[:space:]]/d" "${FORWARD_DB}"
    echo "${SEAFILE_HOSTNAME}    IN    A    ${SEAFILE_IP}" >> "${FORWARD_DB}"
    echo "[OK] Запись обновлена: ${SEAFILE_HOSTNAME} IN A ${SEAFILE_IP}"
  fi
else
  echo "${SEAFILE_HOSTNAME}    IN    A    ${SEAFILE_IP}" >> "${FORWARD_DB}"
  echo "[OK] Добавлена запись: ${SEAFILE_HOSTNAME} IN A ${SEAFILE_IP}"
fi

# ------------------------------------------------------------------
# ШАГ 2. Перезапуск bind9
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: перезапуск bind9 ---"
systemctl restart bind9
sleep 2
echo "[OK] bind9 перезапущен."

# ------------------------------------------------------------------
# ШАГ 3. Проверка DNS
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: проверка DNS ---"
if nslookup "${SEAFILE_HOSTNAME}" >/dev/null 2>&1; then
  nslookup "${SEAFILE_HOSTNAME}"
  RESOLVED_IP=$(nslookup "${SEAFILE_HOSTNAME}" | awk '/^Address: / && !/192\.168\..*\.1$/ {print $2}' | head -1)
  if [[ "${RESOLVED_IP}" == "${SEAFILE_IP}" ]]; then
    echo "[OK] DNS резолвит правильно: ${SEAFILE_HOSTNAME} -> ${SEAFILE_IP}"
  else
    echo "[ПРЕДУПРЕЖДЕНИЕ] DNS вернул неожиданный IP: ${RESOLVED_IP} (ожидался ${SEAFILE_IP})"
    echo "         Проверь: cat ${FORWARD_DB}"
  fi
else
  echo "[ОШИБКА] nslookup ${SEAFILE_HOSTNAME} не удался."
  echo "         Проверь: nano ${FORWARD_DB}"
  echo "         Логи:    tail -40 /var/log/syslog"
  exit 1
fi

echo
echo "================================================================"
echo " Готово! DNS на gateway настроен."
echo " Следующий шаг: выполни seafile_net_hostname.sh на ВМ seafile"
echo "================================================================"
