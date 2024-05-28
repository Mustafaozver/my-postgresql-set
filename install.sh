#!/bin/bash

# PostgreSQL kurulumu
sudo apt update
sudo apt install -y postgresql postgresql-contrib

# PostgreSQL servisinin başlatılması
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Varsayılan PostgreSQL kullanıcısının şifresini ayarlama
POSTGRES_PASSWORD="postgres"

# postgres kullanıcısının şifresini ayarla
sudo -u postgres psql -c "ALTER USER postgres PASSWORD '${POSTGRES_PASSWORD}';"

# pg_hba.conf dosyasını düzenleme
PG_HBA_CONF="/etc/postgresql/$(ls /etc/postgresql)/main/pg_hba.conf"
sudo bash -c "echo 'host    all             all             0.0.0.0/0               md5' >> ${PG_HBA_CONF}"

# postgresql.conf dosyasını düzenleme
POSTGRESQL_CONF="/etc/postgresql/$(ls /etc/postgresql)/main/postgresql.conf"
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" ${POSTGRESQL_CONF}

# PostgreSQL servisinin yeniden başlatılması
sudo systemctl restart postgresql

echo "PostgreSQL kurulumu ve konfigürasyonu tamamlandı."
echo "Varsayılan kullanıcı 'postgres' ve şifresi '${POSTGRES_PASSWORD}' olarak ayarlandı."

# PostgreSQL'e bağlantıyı doğrulama
echo "psql -U postgres -h localhost -W"
