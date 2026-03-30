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

# Имя хоста сервера-шлюза (DNS)
SERVER_HOSTNAME="gateway"

# Имя нового сервера
SEAFILE_HOSTNAME="seafile"

# IP адреса
GW_IP="192.168.${N}.1"
SEAFILE_IP="192.168.${N}.4"

# Сетевой интерфейс ВМ seafile
NET_IF="enp0s3"

# Файл netplan на ВМ seafile
NETPLAN_FILE="/etc/netplan/00-installer-config.yaml"

# Путь к зоне прямого просмотра (на gateway)
FORWARD_DB="/var/lib/bind/forward.db"

# Версия Seafile
SEAFILE_VER="9.0.9"

# Каталог установки
SEAFILE_DIR="/opt/seafile"

# Пользователь системы (от чьего имени работает Seafile)
# Будет определён автоматически как SUDO_USER, можно переопределить здесь:
SEAFILE_SYSTEM_USER="${SUDO_USER:-ubuntu}"
