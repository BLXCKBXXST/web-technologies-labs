#!/usr/bin/env bash
# =============================================================
#  Практическая работа №9 — Часть 1
#  Установка и настройка Ansible на сервере gateway
#
#  Запускать: sudo bash gateway_lab9_setup.sh
#  ВМ: gateway (Ubuntu Server)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №9 — Ansible на ${SERVER_HOSTNAME}"
echo " Домен    : ${DOMAIN}"
echo " Клиент 1 : ${CLIENT1_HOSTNAME} (${CLIENT1_IP})"
echo " Клиент 2 : ${CLIENT2_HOSTNAME} (${CLIENT2_IP})"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Проверка сетевой связности с клиентами
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: проверка связности с клиентами ---"
for HOST in "${CLIENT1_IP}" "${CLIENT2_IP}"; do
  if ping -c 2 -W 2 "${HOST}" &>/dev/null; then
    echo "[OK] ping ${HOST}"
  else
    echo "[ОШИБКА] Нет связи с ${HOST}. Проверь сеть / ВМ." >&2
    exit 1
  fi
done

# ------------------------------------------------------------------
# ШАГ 2. Установка зависимостей Ansible
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: установка python3, pip, openssh-client, sshpass, ansible ---"
apt-get update -y
apt-get install -y python3 python3-pip openssh-client sshpass

# pip install ansible (актуальнее чем пакет из apt)
pip3 install --quiet ansible

ANS_VER=$(ansible --version 2>&1 | head -1)
echo "[OK] Ansible установлен: ${ANS_VER}"

# ------------------------------------------------------------------
# ШАГ 3. Генерация SSH-ключа ed25519 (если нет)
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: генерация SSH-ключа ed25519 ---"

# Определяем реального пользователя (тот, кто вызвал sudo)
REAL_USER="${SUDO_USER:-root}"
REAL_HOME=$(getent passwd "${REAL_USER}" | cut -d: -f6)
SSH_KEY_PATH="${REAL_HOME}/.ssh/id_ed25519"

if [[ -f "${SSH_KEY_PATH}" ]]; then
  echo "[ИНФО] SSH-ключ уже существует: ${SSH_KEY_PATH}"
else
  sudo -u "${REAL_USER}" ssh-keygen -t ed25519 -a 100 -N "" -f "${SSH_KEY_PATH}"
  echo "[OK] SSH-ключ создан: ${SSH_KEY_PATH}"
fi

# ------------------------------------------------------------------
# ШАГ 4. Создание структуры /etc/ansible
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: создание структуры /etc/ansible ---"
mkdir -p "${ANSIBLE_DIR}" "${PLAYBOOKS_DIR}" "${MONITORING_DIR}"
echo "[OK] Директории созданы."

# ------------------------------------------------------------------
# ШАГ 5. Запись /etc/ansible/hosts
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: создание ${HOSTS_FILE} ---"
[[ -f "${HOSTS_FILE}" ]] && cp "${HOSTS_FILE}" "${HOSTS_FILE}.bak_lab9"

cat >"${HOSTS_FILE}" <<EOF
[clients]
${CLIENT1_HOSTNAME} ansible_host=${CLIENT1_IP} ansible_user=${CLIENT1_USER}
${CLIENT2_HOSTNAME} ansible_host=${CLIENT2_IP} ansible_user=${CLIENT2_USER}
EOF

echo "[OK] ${HOSTS_FILE} создан:"
cat "${HOSTS_FILE}"

# ------------------------------------------------------------------
# ШАГ 6. Запись /etc/ansible/ansible.cfg
# ------------------------------------------------------------------
echo
echo "--- Шаг 6: создание ${CFG_FILE} ---"
[[ -f "${CFG_FILE}" ]] && cp "${CFG_FILE}" "${CFG_FILE}.bak_lab9"

cat >"${CFG_FILE}" <<EOF
[defaults]
inventory        = ${HOSTS_FILE}
host_key_checking = False
EOF

echo "[OK] ${CFG_FILE} создан."

# ------------------------------------------------------------------
# ШАГ 7. Запись playbook monitoring.yml
# ------------------------------------------------------------------
echo
echo "--- Шаг 7: создание ${PLAYBOOK_FILE} ---"
[[ -f "${PLAYBOOK_FILE}" ]] && cp "${PLAYBOOK_FILE}" "${PLAYBOOK_FILE}.bak_lab9"

cat >"${PLAYBOOK_FILE}" <<'YAML'
---
- name: collect info to server
  hosts: clients
  gather_facts: true

  tasks:
    - name: create monitoring directory
      file:
        path: /etc/ansible/monitoring
        state: directory
        mode: '0755'
      delegate_to: localhost
      run_once: true

    - name: get free space in root partition
      set_fact:
        root_free_space_gb: >-
          {{
            (
              ansible_mounts
              | selectattr('mount', 'equalto', '/')
              | map(attribute='size_available')
              | first
              | float / 1024 / 1024 / 1024
            ) | round(2)
          }}

    - name: save info file to server
      copy:
        dest: "/etc/ansible/monitoring/{{ inventory_hostname }}_info.txt"
        content: |
          Hostname: {{ ansible_hostname }}
          IP: {{ ansible_default_ipv4.address }}
          OS: {{ ansible_distribution }} {{ ansible_distribution_version }}
          Free disk space on /: {{ root_free_space_gb }} GB
        mode: '0644'
      delegate_to: localhost
YAML

echo "[OK] ${PLAYBOOK_FILE} создан."

# ------------------------------------------------------------------
# ШАГ 8. Итог + инструкция по дальнейшим шагам
# ------------------------------------------------------------------
echo
echo "================================================================"
echo " Установка Ansible завершена."
echo
echo " СЛЕДУЮЩИЙ ОБЯЗАТЕЛЬНЫЙ ШАГ — скопировать SSH-ключ на клиентов:"
echo
echo "   bash gateway_lab9_ssh_copy.sh"
echo
echo " (запускать БЕЗ sudo — ssh-copy-id работает от обычного пользователя)"
echo "================================================================"
