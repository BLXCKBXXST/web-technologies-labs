#!/bin/bash
# =============================================================
# Lab 7 — скрипт для скриншотов (iRedMail)
# Запуск: sudo bash screenshots/screenshots.sh
# Требуется: лабораторная работа №7 выполнена целиком
# =============================================================

step() {
    local NUM="$1"
    local DESC="$2"
    local CMD="$3"

    echo ""
    echo "========================================"
    echo "  [Скриншот ${NUM}] ${DESC}"
    echo "  Файл: img/${NUM}_*.png"
    echo "========================================"
    echo ""
    read -rp "  → Нажми Enter чтобы выполнить команду..."
    echo ""
    eval "$CMD"
    echo ""
    read -rp "  ✔ Сделай скриншот и нажми Enter для продолжения..."
}

clear
echo "=============================================="
echo "  Lab 7 — Скрипт скриншотов"
echo "  Установка и настройка iRedMail"
echo "  Всего: 10 шагов"
echo "=============================================="
echo ""
echo "  ! Шаги 01, 08-10 — ручные (GUI/браузер)."
echo "  ! Шаг 05 выполняется на ВМ gateway."
read -rp "  → Нажми Enter когда будешь готов..."

# === ГЛАВА 2 — ПОДГОТОВКА СТЕНДА ===

# 01 — VirtualBox GUI, вручную
echo ""
echo "========================================"
echo "  [Скриншот 01] Настройка сети ВМ mail в VirtualBox"
echo "  Файл: img/01_vbox_mail_network.png"
echo "  • VirtualBox → mail → Настройка → Сеть"
echo "    Покажи вкладку Адаптер 1 (Внутренняя сеть / intnet)"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 02
step "02" "Вывод ip a на mail (должен быть 192.168.N.5)" \
    "ip a"

# 03
step "03" "Проверка ping и nslookup с mail" \
    "ping -c 4 192.168.29.1 && nslookup gateway.yazikov.iks531.local"

# 04
step "04" "Файл /etc/hosts с FQDN mail.yazikov.iks531.local" \
    "cat /etc/hosts"

# 05 — выполняется на gateway!
echo ""
echo "========================================"
echo "  [Скриншот 05] DNS-запись mail на gateway"
echo "  Файл: img/05_dns_mail_record.png"
echo "  • Перейди на ВМ gateway"
echo "  • Выполни: nslookup mail.yazikov.iks531.local"
echo "    (должен вернуть 192.168.29.5)"
echo "========================================"
read -rp "  ✔ Сделай скриншот на gateway и нажми Enter..."

# === ГЛАВА 3 — ПРОВЕРКА ПОСЛЕ УСТАНОВКИ ===

# 06
echo ""
echo "========================================"
echo "  [Скриншот 06] Статус postfix (active running)"
echo "  Файл: img/06_postfix_status.png"
echo "  Важно: должен быть 'active (running)'"
echo "  Если inactive — проверь /var/log/mail.log"
echo "========================================"
read -rp "  → Нажми Enter чтобы выполнить проверку..."
echo ""
systemctl status postfix || true
echo ""
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 07
echo ""
echo "========================================"
echo "  [Скриншот 07] Статус dovecot (active running)"
echo "  Файл: img/07_dovecot_status.png"
echo "========================================"
read -rp "  → Нажми Enter..."
echo ""
systemctl status dovecot || true
echo ""
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 08 — браузер Desktop
echo ""
echo "========================================"
echo "  [Скриншот 08] Страница входа iRedAdmin (браузер Desktop)"
echo "  Файл: img/08_iredadmin_login.png"
echo "  • Перейди на ВМ Desktop"
echo "  • Открой браузер: https://mail.yazikov.iks531.local/iredadmin"
echo "    (или https://192.168.29.5/iredadmin)"
echo "  • Сделай скриншот страницы авторизации"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 09 — браузер Desktop
echo ""
echo "========================================"
echo "  [Скриншот 09] Дашборд iRedAdmin после входа"
echo "  Файл: img/09_iredadmin_dashboard.png"
echo "  • Логин: postmaster@yazikov.iks531.local"
echo "  • Пароль: тот, что указали при установке"
echo "  • Сделай скриншот дашборда"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 10 — браузер Desktop
echo ""
echo "========================================"
echo "  [Скриншот 10] Страница входа Roundcube Webmail"
echo "  Файл: img/10_roundcube_login.png"
echo "  • В браузере Desktop открой:"
echo "    https://mail.yazikov.iks531.local/mail"
echo "  • Сделай скриншот страницы авторизации"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# Итог
echo ""
echo "=============================================="
echo "  Все 10 скриншотов сделаны!"
echo "  Положи файлы в lab7/latex-report/img/"
echo "  с именами: 01_vbox_mail_network.png ..."
echo "=============================================="
