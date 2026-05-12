# Лабораторная работа №9 — Ansible Monitoring

**Тема:** Установка и настройка Ansible; сбор данных с клиентов на сервер  
**Вариант:** N=29 | Студент: yazikov | Группа: iks531  
**Домен:** `yazikov.iks531.local`

## Скачать

**[📦 Скачать scripts.zip](https://github.com/BLXCKBXXST/web-technologies-labs/releases/download/overleaf-zips/lab9_scripts.zip)**

---

## Виртуальные машины

| ВМ | IP | Роль |
|---|---|---|
| `gateway` | 192.168.29.1 | Ansible control node (сервер сбора данных) |
| `desktop1` | 192.168.29.10 | Ansible client 1 |
| `wordpress` | 192.168.29.6 | Ansible client 2 |

> Используются ВМ из лабораторных работ 5–8. Новые ВМ создавать не нужно.

---

## Файлы

| Файл | ВМ | Описание |
|---|---|---|
| `config.sh` | — | Единый конфиг варианта (IP, пользователи, пути Ansible) |
| `client_lab9_prepare.sh` | `desktop1`, `wordpress` | Установка openssh-server и python3 на клиентах |
| `gateway_lab9_setup.sh` | `gateway` | Установка Ansible, генерация SSH-ключа, создание hosts/ansible.cfg/playbook |
| `gateway_lab9_ssh_copy.sh` | `gateway` | Копирование SSH-ключа на клиентов (без sudo) |
| `gateway_lab9_run.sh` | `gateway` | Запуск playbook и вывод результатов мониторинга (без sudo) |
| `README.md` | — | Этот файл |

---

## Порядок запуска

### 0. Обновить config.sh

Открой `config.sh` и убедись что `CLIENT1_USER` и `CLIENT2_USER` совпадают с реальными именами пользователей на ВМ.

---

### 1. На ВМ `desktop1` и `wordpress` — подготовка клиентов

Скопируй папку `lab9` на каждую клиентскую ВМ (`scp` или `git clone`) и запусти:

```bash
cd web-technologies-labs/lab9
sudo bash client_lab9_prepare.sh
```

Скрипт устанавливает `openssh-server` и `python3`, включает SSH в автозагрузку.

---

### 2. На ВМ `gateway` — установка Ansible

```bash
cd web-technologies-labs/lab9
sudo bash gateway_lab9_setup.sh
```

Скрипт выполняет:
- Проверку связности с клиентами (ping)
- Установку `python3`, `pip3`, `sshpass`, `ansible`
- Генерацию SSH-ключа `ed25519` (если нет)
- Создание `/etc/ansible/hosts`, `/etc/ansible/ansible.cfg`
- Создание playbook `/etc/ansible/playbooks/monitoring.yml`

---

### 3. На ВМ `gateway` — копирование SSH-ключа на клиентов

```bash
bash gateway_lab9_ssh_copy.sh
```

> Запускать **без sudo** — ssh-copy-id работает от обычного пользователя.

Скрипт последовательно запросит пароль каждого клиента, скопирует публичный ключ и в конце проверяет `ansible clients -m ping`.

**Ожидаемый вывод:**
```
desktop1 | SUCCESS => {..."ping": "pong"...}
wordpress | SUCCESS => {..."ping": "pong"...}
```

---

### 4. На ВМ `gateway` — запуск playbook

```bash
bash gateway_lab9_run.sh
```

> Запускать **без sudo** — Ansible берёт SSH-ключ из `~/.ssh/` текущего пользователя.

Скрипт:
- Проверяет `ansible ping`
- Запускает `monitoring.yml`
- Выводит содержимое `/etc/ansible/monitoring/*_info.txt`

**Пример вывода:**
```
=== desktop1_info.txt ===
Hostname: desktop1
IP: 192.168.29.10
OS: Ubuntu 20.04
Free disk space on /: 13.09 GB

=== wordpress_info.txt ===
Hostname: wordpress
IP: 192.168.29.6
OS: Ubuntu 20.04
Free disk space on /: 4.95 GB
```

---

## Траблшутинг

| Симптом | Причина | Решение |
|---|---|---|
| `ansible: command not found` | pip3 install прошёл, но PATH не обновился | `export PATH=$PATH:~/.local/bin` или перелогинься |
| `UNREACHABLE` при ansible ping | SSH не настроен или ключ не скопирован | Проверь `systemctl status ssh` на клиенте; перезапусти `gateway_lab9_ssh_copy.sh` |
| `Permission denied (publickey)` | Неверный `ansible_user` в hosts | Поправь `CLIENT1_USER` / `CLIENT2_USER` в `config.sh` и перезапусти setup |
| `Permission denied (publickey)` | Запустил `gateway_lab9_run.sh` через sudo | Запускай без sudo: `bash gateway_lab9_run.sh` |
| `Number of key(s) added: 0` | Ключ уже был скопирован ранее | Ничего страшного, можно продолжать |
| Playbook падает с `MODULE FAILURE` | Python3 не установлен на клиенте | `sudo apt-get install -y python3` на клиентской ВМ |
| `Destination not writable` | Папка monitoring создана через sudo | `sudo chown -R $USER:$USER /etc/ansible/monitoring` |
| `pip3: command not found` | python3-pip не установлен | `apt-get install -y python3-pip` |
| Нет связи с клиентом | ВМ выключена или не в intnet | Запусти ВМ; проверь адаптер VirtualBox → Internal Network |
