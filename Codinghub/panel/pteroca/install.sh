#!/bin/bash

# Stop script if error occurs
set -e
# Prevent interactive prompts
export DEBIAN_FRONTEND=noninteractive
echo "Updating system..."
apt update -y && apt upgrade -y
echo "Installing required packages..."
apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg lsb-release
echo "Adding PHP repository..."
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
echo "Adding MariaDB repository..."
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash
echo "Adding universe repository..."
add-apt-repository -y universe
echo "Updating repositories..."
apt update -y
echo "Installing PHP, MariaDB, Nginx and dependencies..."
apt -y install php8.2 php8.2-{cli,ctype,iconv,mysql,pdo,mbstring,tokenizer,bcmath,xml,intl,fpm,curl,zip} mariadb-server nginx tar unzip git
echo "Installation completed successfully!"
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
mkdir -p /var/www/pteroca && cd /var/www/pteroca
git clone https://github.com/PteroCA-Org/panel.git ./
COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader
chown -R www-data:www-data /var/www/pteroca/var/ /var/www/pteroca/public/uploads/
chmod -R 775 /var/www/pteroca/var/ /var/www/pteroca/public/uploads/
apt install -y cron
systemctl enable --now cron
(crontab -l 2>/dev/null; echo "* * * * * php /var/www/pteroca/bin/console pteroca:cron:schedule >> /dev/null 2>&1") | crontab -
DB_NAME=pteroca
DB_USER=pterocauser
DB_PASS=1234
mariadb -e "CREATE USER '${DB_USER}'@'127.0.0.1' IDENTIFIED BY '${DB_PASS}';"
mariadb -e "CREATE DATABASE ${DB_NAME};"
mariadb -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'127.0.0.1' WITH GRANT OPTION;"
mariadb -e "FLUSH PRIVILEGES;"
cat /var/www/pteroca/.env | grep DATABASE_URL="mysql://pterocauser:1234@127.0.0.1:3306/pteroca"

















