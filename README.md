# linux-admin-labs

Лабораторные работы по Linux-администрированию (СибГУТИ).  
Предмет: Web-технологии

Среда: VirtualBox + Ubuntu 20.04 Server/Desktop.  
Каждая лаба содержит bash-скрипты для автоматизации и LaTeX-отчёт, готовый для импорта в Overleaf.

---

> ⚠️ **Важно**
>
> Методички преподавателя используют другие версии ВМ и зависимостей — все скрипты в этом репозитории реализованы на **Ubuntu 20.04** с зависимостями под эту версию.  
> Но LaTeX-отчёты написаны в соответствии с требованиями методички и фактическая реализация может отличаться от методички — это нормально.

---

## Скачать Ubuntu 20.04

| Образ | Ссылка |
|-------|--------|
| 🖥️ Ubuntu 20.04 Desktop | [ubuntu-20.04.6-desktop-amd64.iso](https://releases.ubuntu.com/20.04/ubuntu-20.04.6-desktop-amd64.iso) |
| 🔧 Ubuntu 20.04 Server | [ubuntu-20.04.6-live-server-amd64.iso](https://releases.ubuntu.com/20.04/ubuntu-20.04.6-live-server-amd64.iso) |

---

## Лабораторные работы

| Лаба | Тема | Что делается | Скрипты | LaTeX-отчёт | Скриншоты | Методичка |
|------|------|----------------|---------|------------|------------|------------|
| Lab 4 | NAT + DHCP | Настройка шлюза (gateway) с NAT и iptables, установка DHCP-сервера isc-dhcp-server | [lab4/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab4) | [latex-report/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab4/latex-report) | [screenshots/](lab4/latex-report/screenshots/README.md) | [PDF 4](lab4/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab4).pdf) |
| Lab 5 | DNS + DDNS | Установка BIND9, настройка прямой/обратной DNS-зоны, интеграция с DHCP (динамические DNS-записи) | [lab5/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab5) | [latex-report/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab5/latex-report) | [screenshots/](lab5/latex-report/screenshots/README.md) | [PDF 5](lab5/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab5).pdf) |
| Lab 6 | Seafile | Развёртывание облачного хранилища Seafile на MariaDB + Nginx, подключение Desktop-клиента | [lab6/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab6) | [latex-report/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab6/latex-report) | [screenshots/](lab6/latex-report/screenshots/README.md) | [PDF 6](lab6/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab6).pdf) |
| Lab 7 | iRedMail | Настройка полноценного почтового сервера iRedMail (Postfix + Dovecot + OpenLDAP + Nginx), отправка писем | [lab7/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab7) | [latex-report/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab7/latex-report) | [screenshots/](lab7/latex-report/screenshots/README.md) | [PDF 7](lab7/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab7).pdf) |
| Lab 8 | WordPress + PrivateBin | Развёртывание LAMP-стека (Apache2 + MySQL + PHP), установка WordPress и PrivateBin с HTTPS | [lab8/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab8) | [latex-report/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab8/latex-report) | [screenshots/](lab8/latex-report/screenshots/README.md) | [PDF 8](lab8/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab8).pdf) |
| Lab 9 | Ansible Monitoring | Автоматизация сбора информации с узлов сети через Ansible (SSH-ключи, inventory, playbook) | [lab9/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab9) | [latex-report/](https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab9/latex-report) | [screenshots/](lab9/latex-report/screenshots/README.md) | [PDF 9](lab9/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab9).pdf) |

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
│
├── labN/                          ← папка каждой лабораторной работы
│   ├── README.md                  ← описание лабы + ссылка на скачивание scripts.zip
│   ├── config.sh                  ← общие переменные (IP, имя студента, сеть)
│   ├── <vm>_labN_<task>.sh        ← bash-скрипты автоматизации по ВМ и задаче
│   ├── Методичка (labN).pdf       ← PDF методички преподавателя
│   └── latex-report/              ← LaTeX-отчёт для Overleaf
│       ├── README.md              ← ссылка на скачивание overleaf ZIP
│       ├── main.tex               ← точка входа: подключает все части отчёта
│       ├── config.tex             ← настройки студента (номер, ФИО, группа)
│       ├── parts/                 ← разделы отчёта (intro, chap1..N, conclusion)
│       │   ├── title.tex          ← титульная страница
│       │   ├── intro.tex          ← введение
│       │   ├── chap1.tex          ← глава 1 (теория / топология)
│       │   ├── chap2.tex          ← глава 2 (практика / команды)
│       │   ├── chap3.tex          ← глава 3 (результаты / проверка)
│       │   └── conclusion.tex     ← заключение
│       ├── screenshots/           ← скриншоты для отчёта (PNG/JPG)
│       │   ├── screenshots.sh     ← скрипт автоматического сбора скриншотов
│       │   └── README.md          ← список скриншотов с подписями
│       ├── img/                   ← прочие изображения (схемы, диаграммы)
│       ├── fonts/                 ← шрифты (Times New Roman и др. для ГОСТ)
│       └── labN_latex_report.pdf  ← скомпилированный PDF отчёта
│
├── LaTeX_g7-32_template_tsvs-main/  ← базовый LaTeX-шаблон по ГОСТ 7.32
│
└── .github/
    └── workflows/
        └── release-latex.yml      ← GitHub Actions: собирает ZIP для Overleaf
                                      и scripts.zip при каждом push в main
```

---

## 💡 Совет: общая папка VirtualBox (опционально)

Если хочешь редактировать скрипты на хосте и сразу видеть изменения на всех ВМ — настрой глобальную общую папку **один раз** на золотом образе, и все клоны унаследуют её автоматически.

**Шаг 1.** В VirtualBox → Файл → Настройки → Общие папки → Добавить:
- Путь на хосте: папка с репозиторием
- Постоянное подключение: ✅
- Автоподключение: ✅
- Сделать глобальной: ✅

**Шаг 2.** Установить зависимости внутри ВМ (достаточно сделать только на золотом образе):

```bash
sudo apt install -y virtualbox-guest-utils build-essential dkms
sudo usermod -aG vboxsf $USER
# перезагрузить ВМ
```

После перезагрузки папка появится автоматически в `/media/sf_<имя_папки>`. Все клоны этого образа сразу имеют доступ — никакой дополнительной настройки не требуется.

> Настройка выполняется дважды: для золотого образа Server и золотого образа Desktop.  
> Все последующие клоны унаследуют настройку автоматически.
