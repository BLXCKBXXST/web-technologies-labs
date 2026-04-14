#!/bin/bash
# =============================================================
# Lab 9 — скрипт для скриншотов
# Запуск: sudo bash screenshots/screenshots.sh
# Запускать с ВМ: gateway (и по шагам на desktop1/wordpress)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="$(dirname "${SCRIPT_DIR}")"

# Читаем config.sh из папки lab9 (на уровень выше latex-report)
if [[ -f "${LAB_DIR}/../config.sh" ]]; then
  source "${LAB_DIR}/../config.sh"
fi

IMG_DIR="${LAB_DIR}/img"
mkdir -p "${IMG_DIR}"

# --- Функция шага ---
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

clear
echo "================================================"
echo "  Лабораторная работа №9 — Ansible Monitoring"
echo "  Скрипт скриншотов (всего: 14 шагов)"
echo "================================================"
echo ""
echo "  ПОРЯДОК:"
echo "  01-04 — выполняются НА КЛИЕНТАХ (desktop1, wordpress)"
echo "  05-14 — выполняются НА GATEWAY"
echo ""
read -rp "  → Нажми Enter когда будешь готов..."

# ---- ГЛАВА 2 — СТЕНД И ПОДГОТОВКА ----

# 01 — ip a на gateway
step "01" "Сетевые интерфейсы gateway (ip a)" \
  "ip a"

# 02 — статус SSH на desktop1 (переключись на desktop1 вручную)
echo ""
echo "========================================"
echo "  [Скриншот 02] Статус SSH на desktop1"
echo "  Файл: img/02_client_ssh_status.png"
echo "  • Переключись на ВМ desktop1"
echo "  • Выполни: sudo systemctl status ssh"
echo "========================================"
read -rp "  ✔ Сделай скриншот на desktop1 и нажми Enter..."

# 03 — статус SSH на wordpress
echo ""
echo "========================================"
echo "  [Скриншот 03] Статус SSH на wordpress"
echo "  Файл: img/03_wordpress_ssh_status.png"
echo "  • Переключись на ВМ wordpress"
echo "  • Выполни: sudo systemctl status ssh"
echo "========================================"
read -rp "  ✔ Сделай скриншот на wordpress и нажми Enter..."

# 04 — ping клиентов с gateway
step "04" "Ping клиентов с gateway" \
  "ping -c 3 192.168.29.10 && echo '' && ping -c 3 192.168.29.6"

# ---- ГЛАВА 3 — ПРАКТИКА ----

# 05 — ansible --version
step "05" "Версия Ansible (ansible --version)" \
  "ansible --version 2>/dev/null || ~/.local/bin/ansible --version"

# 06 — ssh-keygen
echo ""
echo "========================================"
echo "  [Скриншот 06] Генерация SSH-ключа ed25519"
echo "  Файл: img/06_ssh_keygen.png"
echo "  Команда: ssh-keygen -t ed25519 -a 100"
echo "  Если ключ уже есть — просто нажми Enter дважды для пропуска"
echo "========================================"
read -rp "  → Нажми Enter чтобы выполнить..."
if [[ ! -f ~/.ssh/id_ed25519 ]]; then
  ssh-keygen -t ed25519 -a 100 -N "" -f ~/.ssh/id_ed25519
else
  echo "  [ИНФО] Ключ ~/.ssh/id_ed25519 уже существует."
  ls -la ~/.ssh/id_ed25519*
fi
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 07 — ssh-copy-id desktop1
echo ""
echo "========================================"
echo "  [Скриншот 07] ssh-copy-id на desktop1"
echo "  Файл: img/07_ssh_copy_desktop.png"
echo "  Ожидаемый результат: Number of key(s) added: 1"
echo "========================================"
read -rp "  → Нажми Enter чтобы выполнить (потребуется пароль desktop1)..."
read -rp "  Введи имя пользователя desktop1: " DUSER
ssh-copy-id -i ~/.ssh/id_ed25519.pub "${DUSER:-blxck}@192.168.29.10"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 08 — ssh-copy-id wordpress
echo ""
echo "========================================"
echo "  [Скриншот 08] ssh-copy-id на wordpress"
echo "  Файл: img/08_ssh_copy_wordpress.png"
echo "  Ожидаемый результат: Number of key(s) added: 1"
echo "========================================"
read -rp "  → Нажми Enter чтобы выполнить (потребуется пароль wordpress)..."
read -rp "  Введи имя пользователя wordpress: " WUSER
ssh-copy-id -i ~/.ssh/id_ed25519.pub "${WUSER:-blxck}@192.168.29.6"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 09 — cat /etc/ansible/hosts
step "09" "Инвентарный файл /etc/ansible/hosts" \
  "cat /etc/ansible/hosts"

# 10 — ansible ping
echo ""
echo "========================================"
echo "  [Скриншот 10] ansible clients -m ping"
echo "  Файл: img/10_ansible_ping.png"
echo "  Ожидаемый результат: SUCCESS / pong для обоих клиентов"
echo "========================================"
read -rp "  → Нажми Enter чтобы выполнить..."
ansible clients -m ping 2>/dev/null || ~/.local/bin/ansible clients -m ping
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 11 — cat playbook
step "11" "Содержимое playbook monitoring.yml" \
  "cat /etc/ansible/playbooks/monitoring.yml"

# 12 — запуск playbook
echo ""
echo "========================================"
echo "  [Скриншот 12] Запуск ansible-playbook"
echo "  Файл: img/12_playbook_run.png"
echo "  Ожидаемый результат: failed=0"
echo "========================================"
read -rp "  → Нажми Enter чтобы запустить playbook..."
ansible-playbook /etc/ansible/playbooks/monitoring.yml 2>/dev/null || \
  ~/.local/bin/ansible-playbook /etc/ansible/playbooks/monitoring.yml
read -rp "  ✔ Сделай скриншот (должно быть failed=0) и нажми Enter..."

# 13 — cat desktop1_info.txt
step "13" "Данные мониторинга desktop1" \
  "cat /etc/ansible/monitoring/desktop1_info.txt"

# 14 — cat wordpress_info.txt
step "14" "Данные мониторинга wordpress" \
  "cat /etc/ansible/monitoring/wordpress_info.txt"

echo ""
echo "================================================"
echo "  Все 14 скриншотов сделаны!"
echo "  Положи файлы в lab9/latex-report/img/"
echo "  Именование: 01_gateway_ip_a.png,"
echo "              02_client_ssh_status.png, ..."
echo ""
echo "  Перенос на хост:"
echo "  scp img/*.png user@<host_ip>:/path/to/img/"
echo "================================================"
