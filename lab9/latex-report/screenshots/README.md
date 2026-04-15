# Скриншоты — Лабораторная работа №9

## Запуск

```bash
sudo bash screenshots/screenshots.sh
```

Скрипт проведёт через все 14 шагов в правильном порядке.

## Механика работы

Каждый шаг выглядит так:

```
========================================
  [Скриншот NN] Описание
  Файл: img/NN_название.png
========================================
  → Нажми Enter чтобы выполнить команду...
<выполнение команды>
  ✔ Сделай скриншот и нажми Enter для продолжения...
```

> ⚠️ Шаги 02 и 03 — **ручные**: нужно переключиться на ВМ `desktop1`
> и `wordpress` соответственно, выполнить команду там и вернуться на gateway.

## Таблица скриншотов

| № | Файл | ВМ | Что показать |
|---|---|---|---|
| 01 | `01_gateway_ip_a.png` | gateway | `ip a` — все интерфейсы |
| 02 | `02_client_ssh_status.png` | desktop1 | `systemctl status ssh` |
| 03 | `03_wordpress_ssh_status.png` | wordpress | `systemctl status ssh` |
| 04 | `04_ping_clients.png` | gateway | `ping` до обоих клиентов |
| 05 | `05_ansible_version.png` | gateway | `ansible --version` |
| 06 | `06_ssh_keygen.png` | gateway | генерация ключа `ed25519` |
| 07 | `07_ssh_copy_desktop.png` | gateway | `ssh-copy-id` → desktop1, `Number of key(s) added: 1` |
| 08 | `08_ssh_copy_wordpress.png` | gateway | `ssh-copy-id` → wordpress, `Number of key(s) added: 1` |
| 09 | `09_ansible_hosts.png` | gateway | `cat /etc/ansible/hosts` |
| 10 | `10_ansible_ping.png` | gateway | `ansible clients -m ping` → SUCCESS |
| 11 | `11_playbook_content.png` | gateway | `cat monitoring.yml` |
| 12 | `12_playbook_run.png` | gateway | `ansible-playbook monitoring.yml` → `failed=0` |
| 13 | `13_info_desktop1.png` | gateway | `cat desktop1_info.txt` |
| 14 | `14_info_wordpress.png` | gateway | `cat wordpress_info.txt` |

## Зависимости между шагами

- Шаги 02, 03 — сначала запусти `client_lab9_prepare.sh` на клиентах
- Шаги 07, 08 — потребуют пароль пользователя клиентской ВМ
- Шаги 09–14 — требуют завершённого шага 06 (`ssh-copy-id`)

## 📂 Куда положить скриншоты

Файлы клади в `../img/` с именами **точно как в таблице** (`.png`, без пробелов).