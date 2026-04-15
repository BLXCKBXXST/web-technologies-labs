# linux-admin-labs

Лабораторные работы по Linux-администрированию (СибГУТИ).  
Курс: Web-Technologies / Linux, ИКС-531

Среда: VirtualBox + Ubuntu 20.04/22.04 Server/Desktop.  
Каждая лаба содержит bash-скрипты для автоматизации и LaTeX-отчёт, готовый для импорта в Overleaf.

---

## Лабораторные работы

| Лаба | Тема | Что делается | Скрипты | LaTeX-отчёт | Скриншоты | Методичка |
|------|------|----------------|---------|------------|------------|------------|
| Lab 4 | NAT + DHCP | Настройка шлюза (gateway) с NAT и iptables, установка DHCP-сервера isc-dhcp-server | [lab4/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab4) | [latex-report/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab4/latex-report) | [screenshots/](lab4/latex-report/screenshots/README.md) | [PDF](lab4/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab4).pdf) |
| Lab 5 | DNS + DDNS | Установка BIND9, настройка прямой/обратной DNS-зоны, интеграция с DHCP (динамические DNS-записи) | [lab5/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab5) | [latex-report/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab5/latex-report) | [screenshots/](lab5/latex-report/screenshots/README.md) | [PDF](lab5/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab5).pdf) |
| Lab 6 | Seafile | Развёртывание облачного хранилища Seafile на MariaDB + Nginx, подключение Desktop-клиента | [lab6/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab6) | [latex-report/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab6/latex-report) | [screenshots/](lab6/latex-report/screenshots/README.md) | [PDF](lab6/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab6).pdf) |
| Lab 7 | iRedMail | Настройка полноценного почтового сервера iRedMail (Postfix + Dovecot + OpenLDAP + Nginx), отправка писем | [lab7/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab7) | [latex-report/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab7/latex-report) | [screenshots/](lab7/latex-report/screenshots/README.md) | [PDF](lab7/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab7).pdf) |
| Lab 8 | WordPress + PrivateBin | Развёртывание LAMP-стека (Apache2 + MySQL + PHP), установка WordPress и PrivateBin с HTTPS | [lab8/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab8) | [latex-report/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab8/latex-report) | [screenshots/](lab8/latex-report/screenshots/README.md) | [PDF](lab8/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab8).pdf) |
| Lab 9 | Ansible Monitoring | Автоматизация сбора информации с узлов сети через Ansible (SSH-ключи, inventory, playbook) | [lab9/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab9) | [latex-report/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab9/latex-report) | [screenshots/](lab9/latex-report/screenshots/README.md) | [PDF](lab9/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab9).pdf) |

---

## Топология сети

Все лабы строятся на одной внутренней сети VirtualBox (`intnet`):

```
 Internet
    |
enp0s3 (NAT)
 [gateway]  192.168.N.1
enp0s8 (intnet)
    |
    ├── desktop1    192.168.N.10  (Ubuntu Desktop, DHCP)
    ├── seafile     192.168.N.4   (Seafile)
    ├── mail        192.168.N.5   (iRedMail)
    ├── wordpress   192.168.N.6   (LAMP + WordPress)
    └── privatebin  192.168.N.7   (PrivateBin)
```

> `N` — твой номер студента, задаётся один раз в `config.tex` и проходит через все отчёты автоматически.

---

## Структура репозитория

```
linux-admin-labs/
├── lab4/
│   ├── config.sh
│   ├── gateway_lab4_net.sh
│   ├── gateway_lab4_dhcp.sh
│   ├── desktop_lab4_prepare.sh
│   ├── Методичка (lab4).pdf
│   └── latex-report/
├── lab5/ ...
├── lab6/ ...
├── lab7/ ...
├── lab8/ ...
├── lab9/ ...
└── .github/
    └── workflows/
        └── release-latex.yml  ← автосборка ZIP для Overleaf при каждом push
```
