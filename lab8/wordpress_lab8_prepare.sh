#!/usr/bin/env bash
# =============================================================
#  Практическая работа №8 — WordPress
#  Подготовка ВМ: hostname, hosts, netplan, LAMP, БД, WordPress
#
#  Запускать: sudo bash wordpress_lab8_prepare.sh
#  ВМ: wordpress (192.168.N.6)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №8 — Подготовка ВМ wordpress"
echo " Hostname : ${WP_FQDN}"
echo " IP       : ${WP_IP}"
echo " Домен    : ${DOMAIN}"
echo " Gateway  : ${GW_IP}"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Hostname
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: установка hostname ---"
echo "[ИНФО] Старый hostname: $(hostname)"
hostnamectl set-hostname "${WP_FQDN}"
echo "[OK] hostname = $(hostname -f 2>/dev/null || hostname)"

# ------------------------------------------------------------------
# ШАГ 2. /etc/hosts
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: обновление /etc/hosts ---"
BAK_HOSTS="/etc/hosts.bak_lab8"
[[ -f /etc/hosts ]] && cp /etc/hosts "${BAK_HOSTS}" && echo "[РЕЗЕРВ] /etc/hosts → ${BAK_HOSTS}"

cat > /etc/hosts <<EOF
127.0.0.1   ${WP_FQDN} ${WP_HOSTNAME} localhost
${WP_IP}    ${WP_FQDN} ${WP_HOSTNAME}
EOF
echo "[OK] /etc/hosts обновлён:"
cat /etc/hosts

# ------------------------------------------------------------------
# ШАГ 3. Статический IP (netplan) + статический resolv.conf
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: настройка статического IP (netplan) ---"

BAK_NET="${NETPLAN_FILE}.bak_lab8"
[[ -f "${NETPLAN_FILE}" ]] && cp "${NETPLAN_FILE}" "${BAK_NET}" && echo "[РЕЗЕРВ] ${NETPLAN_FILE} → ${BAK_NET}"

mkdir -p "$(dirname "${NETPLAN_FILE}")"
cat > "${NETPLAN_FILE}" <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    ${NET_IF}:
      dhcp4: no
      addresses: [${WP_IP}/24]
      gateway4: ${GW_IP}
      nameservers:
        addresses: [${GW_IP}]
        search: [${DOMAIN}]
EOF

netplan apply
sleep 2
echo "[OK] netplan применён. IP на ${NET_IF}:"
ip -4 addr show "${NET_IF}" | grep inet || true

# Отключаем systemd-resolved
if systemctl is-active systemd-resolved &>/dev/null; then
  systemctl disable systemd-resolved
  systemctl stop systemd-resolved
  echo "[OK] systemd-resolved отключён"
else
  echo "[ИНФО] systemd-resolved уже отключён"
fi

rm -f /etc/resolv.conf
cat > /etc/resolv.conf <<EOF
nameserver ${GW_IP}
search ${DOMAIN}
EOF
echo "[OK] /etc/resolv.conf перезаписан:"
cat /etc/resolv.conf

# ------------------------------------------------------------------
# ШАГ 4. Проверка сети
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: проверка сети ---"

if ping -c2 -W2 "${GW_IP}" >/dev/null 2>&1; then
  echo "[OK] ping до gateway (${GW_IP}) — успешно"
else
  echo "[ОШИБКА] Нет связи с gateway ${GW_IP}." >&2
  exit 1
fi

RESOLVED=$(dig @"${GW_IP}" "${WP_FQDN}" A +short 2>/dev/null | grep -oP '\d+\.\d+\.\d+\.\d+' | head -1 || true)
if [[ "${RESOLVED}" == "${WP_IP}" ]]; then
  echo "[OK] DNS разрешает ${WP_FQDN} → ${RESOLVED}"
else
  echo "[ОШИБКА] DNS не разрешает ${WP_FQDN} (получено: '${RESOLVED}')." >&2
  exit 1
fi

if ping -c2 -W3 8.8.8.8 >/dev/null 2>&1; then
  echo "[OK] Внешняя сеть (8.8.8.8) доступна"
else
  echo "[ОШИБКА] Нет доступа в интернет. Проверь NAT/MASQUERADE на gateway." >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 5. Обновление пакетов
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: обновление пакетов ---"
apt-get update -q
apt-get upgrade -y
echo "[OK] apt-get update && upgrade завершён"

# ------------------------------------------------------------------
# ШАГ 6. Установка LAMP
# ------------------------------------------------------------------
echo
echo "--- Шаг 6: установка LAMP (Apache2, MySQL/MariaDB, PHP) ---"

apt-get install -y tasksel
DEBIAN_FRONTEND=noninteractive tasksel install lamp-server
echo "[OK] LAMP установлен"

apt-get install -y php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
echo "[OK] PHP-расширения установлены"

# ------------------------------------------------------------------
# ШАГ 7. Настройка Apache2
# ------------------------------------------------------------------
echo
echo "--- Шаг 7: настройка Apache2 ---"

BAK_APACHE="/etc/apache2/apache2.conf.bak_lab8"
cp /etc/apache2/apache2.conf "${BAK_APACHE}"
echo "[РЕЗЕРВ] apache2.conf → ${BAK_APACHE}"

if ! grep -q "^ServerName" /etc/apache2/apache2.conf; then
  echo "ServerName localhost" >> /etc/apache2/apache2.conf
  echo "[OK] ServerName localhost добавлен в apache2.conf"
else
  echo "[OK] ServerName уже задан в apache2.conf"
fi

chown -R www-data:www-data /var/www
chmod -R 755 /var/www
echo "[OK] Права на /var/www выставлены"

systemctl enable apache2
systemctl restart apache2
echo "[OK] Apache2 перезапущен"

# ------------------------------------------------------------------
# ШАГ 8. Настройка БД для WordPress
# ------------------------------------------------------------------
echo
echo "--- Шаг 8: настройка БД WordPress ---"

if systemctl list-units --type=service | grep -q 'mariadb.service'; then
  DB_SERVICE="mariadb"
elif systemctl list-units --type=service | grep -q 'mysql.service'; then
  DB_SERVICE="mysql"
elif dpkg -l mariadb-server &>/dev/null; then
  DB_SERVICE="mariadb"
elif dpkg -l mysql-server &>/dev/null; then
  DB_SERVICE="mysql"
else
  echo "[ОШИБКА] Не найден ни mariadb, ни mysql." >&2
  exit 1
fi
echo "[ИНФО] Обнаружен сервис БД: ${DB_SERVICE}"

systemctl enable "${DB_SERVICE}"
systemctl start  "${DB_SERVICE}"

if [[ "${DB_SERVICE}" == "mysql" ]]; then
  sudo mysql -u root <<SQL
CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_bin;
CREATE USER IF NOT EXISTS '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'${DB_HOST}';
FLUSH PRIVILEGES;
SQL
else
  mysqladmin -u root password "${DB_PASSWORD}" 2>/dev/null || true
  mysql -u root -p"${DB_PASSWORD}" <<SQL
CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_bin;
CREATE USER IF NOT EXISTS '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'${DB_HOST}';
FLUSH PRIVILEGES;
SQL
fi
echo "[OK] БД '${DB_NAME}' и пользователь '${DB_USER}' созданы"

# ------------------------------------------------------------------
# ШАГ 9. Загрузка и настройка WordPress
# ------------------------------------------------------------------
echo
echo "--- Шаг 9: загрузка WordPress ---"

WP_ARCHIVE="/tmp/wordpress.tar.gz"
WP_URL="https://wordpress.org/latest.tar.gz"

# Удаляем архив если он битый
if [[ -f "${WP_ARCHIVE}" ]]; then
  if gzip -t "${WP_ARCHIVE}" 2>/dev/null; then
    echo "[ИНФО] wordpress.tar.gz уже есть в /tmp и целый"
  else
    echo "[ИНФО] wordpress.tar.gz повреждён, удаляю и скачиваю заново"
    rm -f "${WP_ARCHIVE}"
  fi
fi

if [[ ! -f "${WP_ARCHIVE}" ]]; then
  wget -q --show-progress "${WP_URL}" -O "${WP_ARCHIVE}"
  echo "[OK] WordPress скачан"
fi

tar xzvf "${WP_ARCHIVE}" -C /tmp/ >/dev/null
echo "[OK] WordPress распакован"

cd /tmp/wordpress
cp wp-config-sample.php wp-config.php

sed -i "s/database_name_here/${DB_NAME}/" wp-config.php
sed -i "s/username_here/${DB_USER}/" wp-config.php
sed -i "s/password_here/${DB_PASSWORD}/" wp-config.php
sed -i "s/localhost/${DB_HOST}/" wp-config.php
echo "[OK] wp-config.php настроен"

KEYS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/ 2>/dev/null || true)
if [[ -n "${KEYS}" ]]; then
  START_LINE=$(grep -n "AUTH_KEY" wp-config.php | head -1 | cut -d: -f1)
  END_LINE=$(grep -n "NONCE_SALT" wp-config.php | head -1 | cut -d: -f1)
  if [[ -n "${START_LINE}" && -n "${END_LINE}" ]]; then
    sed -i "${START_LINE},${END_LINE}d" wp-config.php
    echo "${KEYS}" | sed -i "${START_LINE}r /dev/stdin" wp-config.php 2>/dev/null || true
  fi
  echo "[OK] Ключи безопасности WordPress обновлены"
else
  echo "[ИНФО] Нет доступа к api.wordpress.org — ключи не обновлены (нормально)"
fi

# ------------------------------------------------------------------
# ШАГ 10. Развёртывание WordPress в /var/www/html
# ------------------------------------------------------------------
echo
echo "--- Шаг 10: развёртывание WordPress ---"

rm -f /var/www/html/index.html
rsync -aq /tmp/wordpress/ /var/www/html/
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
echo "[OK] WordPress скопирован в /var/www/html"

# ------------------------------------------------------------------
# ШАГ 11. Настройка Virtual Host Apache
# ------------------------------------------------------------------
echo
echo "--- Шаг 11: настройка Virtual Host Apache ---"

VHOST_FILE="/etc/apache2/sites-available/wordpress.conf"
cat > "${VHOST_FILE}" <<EOF
<VirtualHost *:80>
    ServerName ${WP_IP}
    ServerAlias ${WP_FQDN}
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/wordpress-error.log
    CustomLog \${APACHE_LOG_DIR}/wordpress-access.log combined
</VirtualHost>
EOF

a2ensite wordpress.conf
a2dissite 000-default.conf 2>/dev/null || true
a2enmod rewrite

systemctl restart apache2
echo "[OK] Virtual Host WordPress настроен и Apache перезапущен"

# ------------------------------------------------------------------
# ПОДСКАЗКА
# ------------------------------------------------------------------
echo
echo "================================================================"
echo " [СЛЕДУЮЩИЙ ШАГ] Установка WordPress через браузер"
echo
echo " На ВМ Desktop откройте браузер Firefox:"
echo "   http://${WP_IP}"
echo "   или http://${WP_FQDN}"
echo
echo " Заполните форму установки:"
echo "   Название сайта : ${DOMAIN}"
echo "   Имя пользователя: admin"
echo "   Пароль         : придумай надёжный"
echo "   Email          : admin@${DOMAIN}"
echo " Нажмите 'Установить WordPress'"
echo
echo " После установки:"
echo "   Вход в панель: http://${WP_IP}/wp-admin"
echo
echo " Затем запусти проверку:"
echo "   sudo bash wordpress_lab8_post.sh"
echo "================================================================"
