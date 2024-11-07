#!/bin/bash
# Настройка необходимого окружения на виртуальной машине

# Обновление системы
apt-get update -y
apt-get upgrade -y

# Установка необходимых пакетов для работы
apt-get install -y python3-pip python3-dev
pip3 install --upgrade pip

