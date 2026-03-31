#!/usr/bin/env bash
# =============================================================
#  Практическая работа №6 — Установка Seafile (пакеты + MariaDB)
#
#  Запускать: sudo bash seafile_install.sh
#  ВМ: seafile (Ubuntu Server 22.04)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №6 — установка зависимостей и MariaDB"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Обновление пакетов
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: apt-get update ---"
apt-get update -y
echo "[OK] Списки пакетов обновлены."

# ------------------------------------------------------------------
# ШАГ 2. Python, dev-пакеты и pkg-config
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: python3, pip, libmysqlclient-dev, pkg-config ---"
apt-get install -y \
  python3 python3-setuptools python3-pip \
  libmysqlclient-dev pkg-config
echo "[OK] Python-пакеты установлены."

# ------------------------------------------------------------------
# ШАГ 3. MariaDB
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: установка MariaDB ---"
apt-get install -y mariadb-server
systemctl enable mariadb
systemctl start mariadb
echo "[OK] MariaDB запущена: $(systemctl is-active mariadb)"

# ------------------------------------------------------------------
# ШАГ 4. Python-зависимости Seafile (может занять несколько минут)
# Pillow зафиксирован на 9.5.0 — версии 10+ несовместимы с Seafile 9.x
# (убрали PIL.Image.ANTIALIAS, seahub падает при старте)
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: pip-зависимости Seafile (ждите ~2-5 мин) ---"
pip3 install --timeout=3600 \
  "django==3.2.*" "Pillow==9.5.0" pylibmc captcha jinja2 \
  "sqlalchemy==1.4.3" django-pylibmc django-simple-captcha \
  python3-ldap mysqlclient "pycryptodome==3.12.0" "cffi==1.14.0"
echo "[OK] Python-зависимости установлены."

# ------------------------------------------------------------------
# ШАГ 5. Скачивание и распаковка Seafile
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: скачивание Seafile ${SEAFILE_VER} ---"
mkdir -p "${SEAFILE_DIR}"
cd "${SEAFILE_DIR}"

TARBALL="seafile-server_${SEAFILE_VER}_x86-64.tar.gz"
URL="https://s3.eu-central-1.amazonaws.com/download.seadrive.org/${TARBALL}"

if [[ -f "${TARBALL}" ]]; then
  echo "[ИНФО] Архив уже скачан, пропускаю загрузку."
else
  echo "[ИНФО] Загружаю ${URL}..."
  wget --show-progress "${URL}"
fi

if [[ ! -d "seafile-server-${SEAFILE_VER}" ]]; then
  echo "[ИНФО] Распаковываю архив..."
  tar -xzf "${TARBALL}"
  echo "[OK] Распаковано в ${SEAFILE_DIR}/seafile-server-${SEAFILE_VER}/"
else
  echo "[ИНФО] Каталог seafile-server-${SEAFILE_VER} уже существует."
fi

# Назначаем владельца каталога текущему пользователю
chown -R "${SEAFILE_SYSTEM_USER}:${SEAFILE_SYSTEM_USER}" "${SEAFILE_DIR}"
echo "[OK] Владелец каталога: ${SEAFILE_SYSTEM_USER}"

echo
echo "================================================================"
echo " Установка зависимостей завершена."
echo ""
echo " [ИНТЕРАКТИВНЫЙ ШАГ] Теперь нужно защитить MariaDB."
echo " Выполни вручную:"
echo ""
echo "   sudo mysql_secure_installation"
echo ""
echo " После этого запусти: sudo bash seafile_setup.sh"
echo "================================================================"
