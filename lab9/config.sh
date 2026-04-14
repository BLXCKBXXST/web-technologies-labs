#!/usr/bin/env bash
# =============================================================
#  ПАРАМЕТРЫ ВАРИАНТА — меняй только здесь под своего студента
# =============================================================

# Номер студента в журнале
N="29"

# Фамилия транслитом
STUDENT="yazikov"

# Номер группы
GROUP="iks531"

# Домен
DOMAIN="${STUDENT}.${GROUP}.local"

# Имя хоста сервера (он же Ansible control node)
SERVER_HOSTNAME="gateway"

# Ansible-клиенты
CLIENT1_HOSTNAME="desktop1"
CLIENT1_IP="192.168.${N}.10"
CLIENT1_USER="blxck"        # <-- поменяй под реального пользователя

CLIENT2_HOSTNAME="wordpress"
CLIENT2_IP="192.168.${N}.6"
CLIENT2_USER="blxck"        # <-- поменяй под реального пользователя

# IP самого gateway
GATEWAY_IP="192.168.${N}.1"

# Пути Ansible
ANSIBLE_DIR="/etc/ansible"
PLAYBOOKS_DIR="${ANSIBLE_DIR}/playbooks"
MONITORING_DIR="${ANSIBLE_DIR}/monitoring"
HOSTS_FILE="${ANSIBLE_DIR}/hosts"
CFG_FILE="${ANSIBLE_DIR}/ansible.cfg"
PLAYBOOK_FILE="${PLAYBOOKS_DIR}/monitoring.yml"

# SSH-ключ (ed25519, без пароля)
SSH_KEY="${HOME}/.ssh/id_ed25519"
