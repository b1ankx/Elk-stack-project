# Проект по настройке ELK-стека и Vault с использованием Vagrant, Docker и Ansible

Этот проект направлен на развертывание и настройку стека ELK (Elasticsearch, Logstash, Kibana) и Vault для обеспечения мониторинга и безопасности в облачной инфраструктуре. 
Конфигурация и настройка выполняются с использованием Vagrant, Docker и Ansible, что обеспечивает легкость развертывания, масштабируемость и автоматизацию. Все необходимые 
компоненты включены в репозиторий, что упрощает процесс развертывания и использования.

## Цели проекта

Проект нацелен на создание инфраструктуры для логирования и мониторинга с использованием ELK-стека и обеспечение безопасного хранения данных с помощью Vault. Это решает 
несколько ключевых задач:
- **Мониторинг**: ELK-стек используется для сбора, индексирования и визуализации данных, что помогает отслеживать производительность и проблемы.
- **Безопасность**: Vault обеспечивает безопасное управление секретами и ключами для хранения конфиденциальных данных.
- **Масштабируемость**: Инфраструктура легко масштабируется, что позволяет увеличивать количество узлов или сервисов без необходимости значительных изменений в основной 
конфигурации.
- **Легкость развертывания**: С использованием Vagrant, Docker и Ansible, развертывание всего стека можно выполнить с минимальными усилиями, используя автоматизацию.

## Структура проекта

Проект состоит из нескольких ключевых компонентов, работающих вместе для обеспечения мониторинга и безопасности:

```
.
├── ansible                  # Каталог с конфигурациями Ansible для автоматизации развертывания
│   ├── ansible.cfg          # Конфигурация Ansible
│   ├── inventory.ini        # Инвентарь для Ansible с информацией о хостах
│   ├── playbook.yml         # Основной плейбук для настройки ELK-стека и Vault
│   ├── roles                # Роли Ansible для настройки ELK-стека и Vault
│   │   ├── elk              # Роль для настройки ELK
│   │   │   ├── tasks
│   │   │   │   └── main.yml # Основной плейбук для настройки ELK
│   │   │   └── templates
│   │   │       ├── elasticsearch.yml.j2 # Шаблон для конфигурации Elasticsearch
│   │   │       ├── kibana.yml.j2        # Шаблон для конфигурации Kibana
│   │   │       └── logstash.conf.j2     # Шаблон для конфигурации Logstash
│   │   └── vault             # Роль для настройки Vault
│   │       ├── tasks
│   │       │   └── main.yml  # Основной плейбук для настройки Vault
│   │       └── templates
│   │           └── vault.hcl.j2  # Шаблон для конфигурации Vault
│   └── vault_vars.yml        # Переменные для настройки Vault
├── docker                   # Конфигурации Docker для контейнеризации
│   ├── Dockerfile            # Dockerfile для создания контейнера с сервисами
│   └── docker-compose.yml    # Docker Compose для удобного управления контейнерами
├── logs                     # Каталог для хранения логов
│   ├── elk-logs             # Логи ELK-стека
│   └── vault-logs           # Логи Vault
├── vagrant                   # Конфигурации Vagrant для создания виртуальных машин
│   ├── Vagrantfile           # Конфигурация Vagrant для создания VM
│   ├── inventory.ini        # Инвентарь для Vagrant
│   ├── provisioning         # Скрипты для инициализации Vagrant
│   │   └── init.sh          # Скрипт для начальной настройки виртуальных машин
│   └── ubuntu-bionic-18.04-cloudimg-console.log  # Логи инстанса Ubuntu Bionic
└── vault                     # Конфигурации Vault
    ├── secrets              # Хранение секретов Vault
    └── vault.hcl            # Основной файл конфигурации Vault
```

## Описание файлов 

В описание приведены некоторые вызерки из файлов проекта, для большей наглядности и понимания структуры

### Каталог `ansible`

- **ansible.cfg**:
  Этот файл конфигурирует поведение Ansible. В нем указывается местоположение инвентаря и другие параметры.
  ```ini
  [defaults]
  inventory = ./inventory.ini
  host_key_checking = False
  ```

- **inventory.ini**:
  Инвентарь для Ansible, где прописаны виртуальные машины для развертывания. Пример:
  ```ini
  [elk]
  elk_host ansible_host=192.168.56.10

  [vault]
  vault_host ansible_host=192.168.56.11
  ```

- **playbook.yml**:
  Основной плейбук для настройки ELK-стека и Vault. Он включает все необходимые шаги для установки и конфигурации сервисов.
  ```yaml
  ---
  - name: Настройка ELK
    hosts: elk
    roles:
      - elk

  - name: Настройка Vault
    hosts: vault
    roles:
      - vault
  ```

- **roles/elk/tasks/main.yml**:
  Этот файл описывает шаги для установки и настройки компонентов ELK-стека.
  ```yaml
  - name: Установка Elasticsearch
    apt:
      name: elasticsearch
      state: present

  - name: Конфигурация Elasticsearch
    template:
      src: elasticsearch.yml.j2
      dest: /etc/elasticsearch/elasticsearch.yml
  ```

- **roles/elk/templates/elasticsearch.yml.j2**:
  Шаблон конфигурации для Elasticsearch, где прописаны ключевые параметры.
  ```yaml
  cluster.name: "my-cluster"
  node.name: "node-1"
  path.data: /var/lib/elasticsearch
  ```

- **roles/vault/templates/vault.hcl.j2**:
  Шаблон для настройки Vault, в котором указывается конфигурация для хранения секретов.
  ```hcl
  listener "tcp" {
    address = "0.0.0.0:8200"
    tls_disable = 1
  }

  storage "file" {
    path = "/opt/vault/data"
  }

  ui = true
  ```

- **vault_vars.yml**:
  Переменные для настройки Vault, такие как секреты или доступ к хранилищу данных.
  ```yaml
  vault_token: "your-vault-token"
  ```

### Каталог `docker`

- **Dockerfile**:
  В нем описывается, как создавать Docker-образы для необходимых сервисов.
  ```dockerfile
  FROM ubuntu:20.04
  RUN apt-get update && apt-get install -y \
    elasticsearch \
    kibana \
    logstash
  ```

- **docker-compose.yml**:
  Этот файл описывает, как запускать несколько контейнеров с сервисами ELK.
  ```yaml
  version: '3'
  services:
    elasticsearch:
      image: elasticsearch:7.10.0
      ports:
        - "9200:9200"
    kibana:
      image: kibana:7.10.0
      ports:
        - "5601:5601"
    logstash:
      image: logstash:7.10.0
  ```

### Каталог `vagrant`

- **Vagrantfile**:
  Файл конфигурации для Vagrant, который описывает создание виртуальных машин и их настройки.
  ```ruby
  Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/bionic64"
    config.vm.network "private_network", type: "dhcp"
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
  end
  ```

- **provisioning/init.sh**:
  Скрипт, который выполняет начальную настройку виртуальных машин. Пример:
  ```bash
  #!/bin/bash
  apt-get update
  apt-get install -y ansible
  ```

### Каталог `vault`

- **secrets**:
  Каталог для хранения секретов, которые Vault будет защищать.

- **vault.hcl**:
  Основной конфигурационный файл Vault, который указывает, как и где хранить секреты и данные.
  ```hcl
  storage "file" {
    path = "/opt/vault/data"
  }
  listener "tcp" {
    address = "0.0.0.0:8200"
    tls_disable = 1
  }
  ```
