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

# Домен (собирается автоматически из STUDENT и GROUP)
DOMAIN="${STUDENT}.${GROUP}.local"

# Имя хоста сервера-шлюза
SERVER_HOSTNAME="gateway"

# Имя хоста клиентской машины (для подсказок)
DESKTOP_HOSTNAME="desktop1"

# Сетевые интерфейсы сервера gateway
NET_IF_EXT="enp0s3"   # внешний (NAT / мост)
NET_IF_INT="enp0s8"   # внутренний (Internal Network)

# Внешний IP (NAT в VirtualBox — одинаково для всех)
EXT_IP="10.0.2.15/24"
EXT_GW="10.0.2.2"
EXT_DNS="8.8.8.8"

# Файл netplan на сервере
NETPLAN_FILE="/etc/netplan/00-installer-config.yaml"

# Файл сохранённых правил iptables
IPTABLES_RULES="/etc/iptables/rules.v4"
