# Используем официальный образ Vault
FROM hashicorp/vault:latest

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /vault

# Копируем конфигурацию Vault и секреты (если нужно)
COPY config/vault.hcl /etc/vault.d/vault.hcl
COPY secrets/ /vault/secrets/

# Устанавливаем права доступа (если нужно)
RUN chmod 777 /vault/secrets

# Открываем порт для доступа к Vault
EXPOSE 8200

# Стартуем Vault с конфигурацией
CMD ["vault", "server", "-config=/etc/vault.d/vault.hcl"]

