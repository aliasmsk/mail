# 📬 Production-Grade Immutable Mail Stack

![Docker](https://img.shields.io/badge/Docker-29.7.2-2496ED?logo=docker&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-2.16.3-EE0000?logo=ansible&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15--alpine-4169E1?logo=postgresql&logoColor=white)

Автоматизированный, отказоустойчивый почтовый стек (Postfix, Dovecot, PostgreSQL, OpenDKIM, Nginx, Roundcube, Certbot), развернутый на VPS по принципам **Immutable Infrastructure** и **12-Factor App** с помощью **Docker**, **Ansible** и **GitHub Actions**.

---

## 💡 Ключевые инженерные решения

* **Immutable Infrastructure & Baked-in Configs:** Статическая конфигурация Postfix и Dovecot запечена в кастомные Docker-образы на базе Alpine Linux. Это исключает дрифт конфигураций (Configuration Drift) между окружениями.
* **Безопасная шаблонизация (`envsubst`):** Все динамические параметры (подключения к БД, домены, хосты) передаются через переменные окружения и подставляются в `.template` файлы в момент запуска контейнеров через `entrypoint.sh`.
* **Автоматизация SSL & DKIM:** Сертификаты Let's Encrypt автоматически ротируются между Nginx, Postfix и Dovecot. Генерация и подстановка ключей OpenDKIM полностью автоматизированы в Ansible.
* **Атомарные релизы:** Каждая сборка в GitHub Actions тегируется SHA-хэшем коммита, обеспечивая детерминированность и быстрый откат (Rollback).

---

## 🛠 Технологический стек

* **MTA / MDA:** Postfix 3.8.13, Dovecot 2.3.21 (SMTP, IMAP, LMTP, SASL Auth)
* **Database:** PostgreSQL 15.19 Alpine (хранение виртуальных доменов, пользователей и алиасов)
* **Security & Web:** OpenDKIM, Fail2ban, UFW, Nginx, Certbot
* **Webmail:** Roundcube
* **IaC & CI/CD:** Ansible, Docker Compose v5.5.0, GitHub Actions (ansible-lint, Docker Buildx, SSH Deploy)

---

## 🚀 Быстрый старт (Деплой через Ansible)

### 1. Требования
* Ubuntu Server 22.04 с публичным IP
* **Настроенные DNS-записи домена:**
  * **A-запись:** `mail.example.com` $\rightarrow$ `IP_ВАШЕГО_VPS` (привязка поддомена почты)
  * **MX-запись:** `@` $\rightarrow$ `mail.example.com` (указывает, куда доставлять входящие письма)
  * **SPF (TXT):** `@` $\rightarrow$ `v=spf1 ip4:IP_ВАШЕГО_VPS ~all` (разрешает отправку почты только с вашего IP)
  * **DKIM (TXT):** `mail._domainkey` $\rightarrow$ `v=DKIM1; k=rsa; p=...` (подпись писем для защиты от подделки)
  * **DMARC (TXT):** `_dmarc` $\rightarrow$ `v=DMARC1; p=none; rua=mailto:admin@example.com` (политика проверки подлинности)
* **PTR-запись (Reverse DNS):** Настраивается в панели провайдера VPS (`IP_ВАШЕГО_VPS` $\rightarrow$ `mail.example.com`). *Критично для прохождения проверок спам-фильтров Gmail/Yandex.*

### 2. Запуск локально
1. Настройте `inventory.ini` и переменные в `group_vars/all.yml` (домен, пароли БД, список почтовых ящиков).
2. Выполните запуск плейбука:
   ```bash
   ansible-playbook -i inventory.ini site.yml

🔄 CI/CD Пайплайн (GitHub Actions)
При пуше в ветку main запускается автоматический workflow:

Linting: Проверка ролей через ansible-lint.

Build & Push: Сборка и пуш Docker-образов Postfix и Dovecot в реестр с тегами ${{ github.sha }} и latest.

Deploy: Подключение к VPS по SSH, запуск ansible плейбука.
