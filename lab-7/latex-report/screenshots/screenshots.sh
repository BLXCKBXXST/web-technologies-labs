#!/bin/bash
# =============================================================
# Lab 7 — скрипт для скриншотов
# Запуск: sudo bash screenshots/screenshots.sh
# Требуется: лаб.5 выполнена (gateway, DNS, DHCP работают)
# Выполнять на ВМ mail (кроме шагов на gateway и Desktop)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="$(dirname "${SCRIPT_DIR}")"
source "${LAB_DIR}/../../lab-7/config.sh" 2>/dev/null || {
  # Запасные значения если config.sh не найден
  N="29"
  DOMAIN="yazikov.iks531.local"
  MAIL_IP="192.168.29.5"
  GW_IP="192.168.29.1"
  NET_IF="enp0s3"
}

step() {
    local NUM="$1"
    local DESC="$2"
    local CMD="$3"

    echo ""
    echo "========================================"
    echo "  [Скриншот ${NUM}] ${DESC}"
    echo "========================================"
    echo "  Файл: img/${NUM}_*.png"
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
echo "  Установка iRedMail (электронная почта)"
echo "  Всего: 23 шага"
echo "=============================================="
echo ""
echo "  ! Скриншот 01 (настройка VirtualBox) — вручную."
echo "    Покажи вкладку Сеть ВМ mail в VirtualBox GUI."
read -rp "  → Нажми Enter когда будешь готов..."

# ================ ГЛАВА 2 — ПОДГОТОВКА СТЕНДА ================

# 01 — VirtualBox вручную
echo ""
echo "========================================"
echo "  [Скриншот 01] Настройка адаптеров ВМ mail в VirtualBox"
echo "  Файл: img/01_vbox_mail_settings.png"
echo "  • VirtualBox → mail → Настройки → Сеть"
echo "    Покажи Адаптер 1: Внутренняя сеть, intnet"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 02
step "02" "Файл netplan /etc/netplan/01-netcfg.yaml" \
    "cat /etc/netplan/01-netcfg.yaml 2>/dev/null || echo 'Файл не найден'"

# 03
echo ""
echo "========================================"
echo "  [Скриншот 03] FQDN хоста mail (hostname -f)"
echo "  Файл: img/03_hostname_fqdn.png"
echo "========================================"
read -rp "  → Нажми Enter чтобы выполнить..."
echo ""
hostname -f
cat /etc/hosts
echo ""
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 04 — DNS разрешение имени mail (на ВМ mail)
echo ""
echo "========================================"
echo "  [Скриншот 04] nslookup mail — разрешение DNS"
echo "  Файл: img/04_nslookup_mail.png"
echo "  Убедись что DNS указывает на ${GW_IP}"
echo "========================================"
read -rp "  → Нажми Enter чтобы выполнить..."
echo ""
nslookup mail || echo "[ошибка] DNS не отвечает. Проверь gateway_add_mail_dns.sh"
echo ""
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 05 — ping интернет
step "05" "Доступ в интернет с ВМ mail (ping ya.ru)" \
    "ping -c3 ya.ru && echo '--- OK: интернет есть ---'"

# ================ ГЛАВА 3 — УСТАНОВКА IREDMAIL ================

# 06
echo ""
echo "========================================"
echo "  [Скриншот 06] Скачивание архива iRedMail (wget)"
echo "  Файл: img/06_wget_iredmail.png"
echo "  Запусти в другом окне (wget уже должен быть выполнен):"
echo "  wget https://github.com/iredmail/iRedMail/archive/refs/tags/1.6.2.tar.gz"
echo "  Покажи финальную строку: 100% [...] saved"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 07
echo ""
echo "========================================"
echo "  [Скриншот 07] Завершение pkgs/get_all.sh"
echo "  Файл: img/07_get_all_done.png"
echo "  Запусти в отдельном окне get_all.sh и когда"
echo "  он завершится — сделай скриншот последних строк вывода."
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 08–13 — интерактивные шаги установщика iRedMail
echo ""
echo "=============================================="
echo "  [Скриншоты 08–13] Установщик iRedMail (./iRedMail.sh)"
echo "  Файлы: img/08_install_storage.png ... img/13_install_components.png"
echo ""
echo "  Сделай скриншоты каждого экрана установщика:"
echo "    08 — Default mail storage path   (Enter, оставить /var/vmail)"
echo "    09 — Preferred web server        (Nginx)"
echo "    10 — Backend                     (OpenLDAP)"
echo "    11 — LDAP suffix                 (dc=yazikov,dc=iks531,dc=local)"
echo "    12 — First mail domain name      (yazikov.iks531.local)"
echo "    13 — Optional components         (Roundcube, netdata, iRedAdmin, Fail2ban)"
echo "=============================================="
read -rp "  ✔ Все 6 скриншотов сделаны? Нажми Enter..."

# 14 — финальный экран установщика
echo ""
echo "========================================"
echo "  [Скриншот 14] Завершение установки iRedMail"
echo "  Файл: img/14_install_done.png"
echo "  Покажи экран: Installation of iRedMail completed"
echo "  (или последние строки вывода установщика)"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 15 — статус сервисов после перезагрузки
echo ""
echo "========================================"
echo "  [Скриншот 15] Статус сервисов (postfix, dovecot, nginx, slapd)"
echo "  Файл: img/15_services_status.png"
echo "  Убедись что все сервисы active (running)"
echo "========================================"
read -rp "  → Нажми Enter чтобы выполнить..."
echo ""
for SVC in postfix dovecot nginx slapd; do
    systemctl is-active "${SVC}" >/dev/null 2>&1 \
        && echo "  [OK] ${SVC}: active" \
        || echo "  [ОШИБКА] ${SVC}: НЕ запущен"
done
echo ""
systemctl --no-pager status postfix | head -6
echo ""
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 16 — iRedAdmin логин (Desktop)
echo ""
echo "========================================"
echo "  [Скриншот 16] Форма входа iRedAdmin (с Desktop)"
echo "  Файл: img/16_iredadmin_login.png"
echo "  На Desktop: открой Firefox →"
echo "  https://mail.${DOMAIN}/iredadmin"
echo "  Покажи форму входа (принять самоподписанный сертификат)"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 17 — создание пользователя iRedAdmin
echo ""
echo "========================================"
echo "  [Скриншот 17] Создание пользователя в iRedAdmin"
echo "  Файл: img/17_iredadmin_add_user.png"
echo "  На Desktop: iRedAdmin → Users → Add user"
echo "  Email: user1@${DOMAIN}"
echo "========================================"
read -rp "  ✔ Сделай скриншот (форму создания) и нажми Enter..."

# 18 — список пользователей
echo ""
echo "========================================"
echo "  [Скриншот 18] Список пользователей iRedAdmin"
echo "  Файл: img/18_iredadmin_user_list.png"
echo "  Покажи список: postmaster и user1 в таблице"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 19 — Roundcube Inbox
echo ""
echo "========================================"
echo "  [Скриншот 19] Roundcubemail — входящие"
echo "  Файл: img/19_roundcube_inbox.png"
echo "  На Desktop: https://mail.${DOMAIN}/mail"
echo "  Войди как postmaster@${DOMAIN}"
echo "========================================"
read -rp "  ✔ Сделай скриншот (Inbox) и нажми Enter..."

# 20 — создание письма Roundcube
echo ""
echo "========================================"
echo "  [Скриншот 20] Roundcubemail — окно создания письма"
echo "  Файл: img/20_roundcube_compose.png"
echo "  Compose → To: user1@${DOMAIN}, Subject: Тест ЛР-7"
echo "========================================"
read -rp "  ✔ Сделай скриншот (форму Compose) и нажми Enter..."

# 21 — Inbox user1 с полученным письмом
echo ""
echo "========================================"
echo "  [Скриншот 21] Inbox user1 с полученным письмом"
echo "  Файл: img/21_roundcube_received.png"
echo "  Войди как user1@${DOMAIN} → открой Inbox"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 22 — открытое письмо
echo ""
echo "========================================"
echo "  [Скриншот 22] Открытое письмо в Roundcube"
echo "  Файл: img/22_roundcube_open_letter.png"
echo "  Открой письмо, покажи тему и содержимое"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 23 — лог Postfix
step "23" "Лог Postfix /var/log/mail.log (status=sent)" \
    "tail -30 /var/log/mail.log 2>/dev/null || journalctl -u postfix --no-pager | tail -30"

# Итог
echo ""
echo "=============================================="
echo "  Все 23 скриншота сделаны!"
echo "  Положи PNG-файлы в lab-7/latex-report/img/"
echo "  с именами: 01_vbox_mail_settings.png ..."
echo ""
echo "  Перенести скриншоты на хост:"
echo "  scp img/*.png user@<HOST_IP>:/path/to/lab-7/latex-report/img/"
echo "=============================================="
