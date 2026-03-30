#!/usr/bin/env bash
# =============================================================
#  Практическая работа №8 — Клиентская ВМ
#  Настройка почтового клиента + подсказки по GUI (Thunderbird)
#
#  Запускать: sudo bash desktop_lab8_client.sh
#  ВМ: Desktop (Ubuntu Desktop)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №8 — Почтовый клиент на ${DESKTOP_HOSTNAME}"
echo " Сервер : ${MAIL_FQDN} (${SRV_IP})"
echo " Домен  : ${DOMAIN}"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Проверка сетевой доступности почтового сервера
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: проверка соединения с почтовым сервером ---"
if ping -c 3 -W 2 "${SRV_IP}" >/dev/null 2>&1; then
  echo "[OK] ${SRV_IP} доступен (ping)."
else
  echo "[ОШИБКА] ${SRV_IP} недоступен. Проверь сетевые настройки Desktop."
fi

# Проверка SMTP (порт 25)
if nc -zw3 "${SRV_IP}" 25 2>/dev/null; then
  echo "[OK] SMTP порт 25 открыт."
else
  echo "[ОШИБКА] SMTP порт 25 недоступен с Desktop."
fi

# Проверка IMAP (порт 143)
if nc -zw3 "${SRV_IP}" 143 2>/dev/null; then
  echo "[OK] IMAP порт 143 открыт."
else
  echo "[ОШИБКА] IMAP порт 143 недоступен с Desktop."
fi

# ------------------------------------------------------------------
# ШАГ 2. Установка Thunderbird и вспомогательных пакетов
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: установка Thunderbird и netcat ---"
DEBIAN_FRONTEND=noninteractive apt-get install -y thunderbird netcat-openbsd
echo "[OK] Thunderbird установлен."

# ------------------------------------------------------------------
# ШАГ 3. Установка mutt для проверки через CLI
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: установка mutt (CLI почтовый клиент) ---"
DEBIAN_FRONTEND=noninteractive apt-get install -y mutt
echo "[OK] mutt установлен."

# ------------------------------------------------------------------
# ШАГ 4. Подсказки по настройке Thunderbird (GUI)
# ------------------------------------------------------------------
echo
echo "================================================================"
echo " [ИНТЕРАКТИВНЫЙ ШАГ] Настрой Thunderbird вручную:"
echo
echo " 1. Запусти Thunderbird: Applications → Internet → Thunderbird"
echo " 2. Edit → Account Settings → Add Mail Account"
echo
echo " --- Учётная запись user1 ---"
echo "   Ваше имя    : User One"
echo "   E-mail      : ${MAIL_USER1}@${DOMAIN}"
echo "   Пароль      : ${MAIL_USER1_PASS}"
echo
echo " --- Параметры входящей почты (IMAP) ---"
echo "   Протокол    : IMAP"
echo "   Сервер      : ${SRV_IP}"
echo "   Порт        : 143"
echo "   Защита      : None"
echo "   Аутентификация: Normal password"
echo "   Логин       : ${MAIL_USER1}"
echo
echo " --- Параметры исходящей почты (SMTP) ---"
echo "   Сервер      : ${SRV_IP}"
echo "   Порт        : 25"
echo "   Защита      : None"
echo "   Аутентификация: Normal password"
echo "   Логин       : ${MAIL_USER1}"
echo
echo " 3. После настройки — отправь тестовое письмо:"
echo "   Кому   : ${MAIL_USER2}@${DOMAIN}"
echo "   Тема   : Test from Thunderbird"
echo "================================================================"
echo
echo "--- Шаг 4: проверка получения почты через mutt (CLI) ---"
echo
echo " Запусти в терминале (от обычного пользователя, не root):"
echo "   sudo -u ${MAIL_USER1} mutt -f imaps://${MAIL_USER1}:${MAIL_USER1_PASS}@${SRV_IP}:143"
echo
echo " Или простая телнет-проверка IMAP:"
echo "   telnet ${SRV_IP} 143"
echo "   a001 LOGIN ${MAIL_USER1} ${MAIL_USER1_PASS}"
echo "   a002 SELECT INBOX"
echo "   a003 LOGOUT"
echo
echo "================================================================"
echo " Настройка почтового клиента на Desktop завершена."
echo "================================================================"
