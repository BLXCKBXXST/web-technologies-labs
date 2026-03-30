#!/usr/bin/env bash
# =============================================================
#  ПАРАМЕТРЫ ВАРИАНТА — меняй только здесь под своего студента
# =============================================================

# Номер студента в журнале
N="14"

# Фамилия транслитом
STUDENT="mazurina"

# Номер группы
GROUP="iks531"

# Домен (собирается автоматически)
DOMAIN="${STUDENT}.${GROUP}.local"

# Домен в ВЕРХНЕМ регистре (для Samba AD)
DOMAIN_UPPER="MAZURINA.IKS531.LOCAL"

# NetBIOS-имя домена (не более 15 символов)
NETBIOS_DOMAIN="MAZURINA"

# Имя хоста сервера-шлюза / AD DC
SERVER_HOSTNAME="gateway"

# Имя хоста клиентской машины
DESKTOP_HOSTNAME="desktop1"

# Сетевые интерфейсы сервера gateway
NET_IF_EXT="enp0s3"   # внешний (NAT / мост)
NET_IF_INT="enp0s8"   # внутренний (Internal Network)

# IP адрес сервера в локальной сети
SRV_IP="192.168.${N}.1"

# Внешний IP (NAT в VirtualBox)
EXT_IP="10.0.2.15/24"
EXT_GW="10.0.2.2"

# Файл netplan на сервере
NETPLAN_FILE="/etc/netplan/00-installer-config.yaml"

# Пароль администратора домена (используется при provisioning)
ADMIN_PASS="Admin1234!"

# Тестовые пользователи
USER1_LOGIN="user1"
USER1_PASS="User1pass!"
USER2_LOGIN="user2"
USER2_PASS="User2pass!"

# Общие папки (имена шаров)
SHARE_PUBLIC="public"
SHARE_SECRET="secret"

# Пути к папкам шаров
SHARE_PUBLIC_PATH="/srv/samba/public"
SHARE_SECRET_PATH="/srv/samba/secret"
