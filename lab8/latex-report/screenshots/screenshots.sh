#!/bin/bash
# =============================================================
# Lab 8 — скрипт для скриншотов (WordPress / LAMP)
# Запуск: sudo bash screenshots/screenshots.sh
# Требуется: лабораторные 4 и 5 выполнены (gateway, DNS, DHCP)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="$(dirname "${SCRIPT_DIR}")"

# Загружаем config из lab8/
source "${LAB_DIR}/../config.sh"

IMG_DIR="${LAB_DIR}/img"
mkdir -p "${IMG_DIR}"

# -------------------------------------------------------
step() {
    local NUM="$1"
    local DESC="$2"
    local CMD="$3"

    echo ""
    echo "========================================"
    echo "  [Скриншот ${NUM}] ${DESC}"
    echo "  Файл: img/${NUM}_*.png"
    echo "========================================"
    read -rp "  → Нажми Enter чтобы выполнить команду..."
    echo ""
    eval "${CMD}"
    echo ""
    read -rp "  ✔ Сделай скриншот и нажми Enter для продолжения..."
}
# -------------------------------------------------------

clear
echo "=============================================="
echo "  Lab 8 — Скрипт скриншотов"
echo "  WordPress / LAMP"
echo "  Всего: 12 шагов"
echo "=============================================="
echo ""
echo "  Скриншоты 01 и 08 делаются вручную (VirtualBox GUI и браузер)."
read -rp "  → Нажми Enter когда будешь готов..."

# ============================================================
# ГЛАВА 2 — Подготовка стенда
# ============================================================

# 01 — VirtualBox GUI (вручную)
echo ""
echo "========================================"
echo "  [Скриншот 01] Настройка адаптера ВМ wordpress в VirtualBox"
echo "  Файл: img/01_vbox_wordpress_settings.png"
echo "  • VirtualBox → wordpress → Настройка → Сеть"
echo "    Показать: Адаптер 1 → Internal Network (intnet)"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 02 — Результат gateway_lab8_dns.sh
step "02" \
    "Результат gateway_lab8_dns.sh (DNS A+PTR для wordpress добавлены)" \
    "echo 'Покажи терминал с выводом последнего запуска gateway_lab8_dns.sh на gateway'; \
     echo 'Если не запускал — запусти сейчас: sudo bash lab8/gateway_lab8_dns.sh'; \
     echo 'Ожидаемый вывод: [OK] DNS: wordpress.${WP_FQDN} → ${WP_IP}'"

# 03 — Сетевая проверка на wordpress
step "03" \
    "Ping до gateway и DNS-резолвинг с ВМ wordpress" \
    "ping -c3 ${GW_IP} && echo '' && dig @${GW_IP} ${WP_FQDN} A +short"

# ============================================================
# ГЛАВА 3 — Практическая часть
# ============================================================

# 04 — Статус Apache2
step "04" \
    "Статус сервиса Apache2 (active running)" \
    "systemctl status apache2 --no-pager -l | head -20"

# 05 — Файл Virtual Host
step "05" \
    "Конфигурация Virtual Host Apache для WordPress" \
    "cat /etc/apache2/sites-enabled/wordpress.conf 2>/dev/null || \
     cat /etc/apache2/sites-available/wordpress.conf 2>/dev/null || \
     echo 'Файл не найден — запусти wordpress_lab8_prepare.sh'"

# 06 — Статус MariaDB
step "06" \
    "Статус MariaDB и наличие БД wordpress" \
    "systemctl status mariadb --no-pager -l | head -15 && \
     echo '' && \
     mysql -u ${DB_USER} -p${DB_PASSWORD} \
       -e 'SHOW DATABASES;' 2>/dev/null || true"

# 07 — Файлы WordPress в /var/www/html
step "07" \
    "Файлы WordPress развёрнуты в /var/www/html" \
    "ls -la /var/www/html/ | head -20"

# 08 — Мастер установки в браузере (вручную, Desktop)
echo ""
echo "========================================"
echo "  [Скриншот 08] Мастер установки WordPress в браузере"
echo "  Файл: img/08_wp_installer.png"
echo "  • Перейди на ВМ desktop1"
echo "  • Открой браузер Firefox: http://${WP_IP}/"
echo "  • Заполни форму установки:"
echo "      Название сайта : ${DOMAIN}"
echo "      Имя пользователя: admin"
echo "      Email           : admin@${DOMAIN}"
echo "  • Нажми 'Установить WordPress'"
echo "  • Сделай скриншот страницы установки ДО нажатия кнопки"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 09 — Успешное завершение установки
echo ""
echo "========================================"
echo "  [Скриншот 09] Успешное завершение установки WordPress"
echo "  Файл: img/09_wp_install_success.png"
echo "  • Сделай скриншот страницы 'Установка завершена!'"
echo "  • Затем войди: admin / <твой пароль>"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 10 — Панель администратора
echo ""
echo "========================================"
echo "  [Скриншот 10] Панель администратора WordPress"
echo "  Файл: img/10_wp_admin_panel.png"
echo "  • Открой: http://${WP_IP}/wp-admin"
echo "  • Сделай скриншот главной страницы Dashboard"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 11 — Тестовая запись
echo ""
echo "========================================"
echo "  [Скриншот 11] Тестовая запись опубликована"
echo "  Файл: img/11_wp_post_published.png"
echo "  • WordPress Admin → Записи → Добавить новую"
echo "  • Заполни заголовок и текст → Опубликовать"
echo "  • Открой главную страницу http://${WP_IP}/ и убедись"
echo "    что запись отображается"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 12 — Результат проверочного скрипта
step "12" \
    "Результат проверочного скрипта wordpress_lab8_post.sh" \
    "bash ${LAB_DIR}/../wordpress_lab8_post.sh 2>&1 || true"

# ============================================================
echo ""
echo "=============================================="
echo "  Все 12 скриншотов сделаны!"
echo "  Положи PNG-файлы в lab8/latex-report/img/"
echo "  Имена файлов:"
echo "    01_vbox_wordpress_settings.png"
echo "    02_gateway_dns_result.png"
echo "    03_wp_network_check.png"
echo "    04_apache2_status.png"
echo "    05_vhost_conf.png"
echo "    06_mariadb_status.png"
echo "    07_wp_files.png"
echo "    08_wp_installer.png"
echo "    09_wp_install_success.png"
echo "    10_wp_admin_panel.png"
echo "    11_wp_post_published.png"
echo "    12_post_check.png"
echo "=============================================="
