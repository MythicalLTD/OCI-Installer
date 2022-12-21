#!/bin/bash
set -e
if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi
echo "  Welcome to MythicalNodes Panel Script"
echo "With this script you can setup your server"
echo "         On your ubuntu server"
echo "       Copyright 2022 MythicalNodes"
read -p "Press any key to start installing ..."
cd /etc/ssh
rm sshd_config
curl -o sshd_config https://raw.githubusercontent.com/MythicalNodes/OCI-Installer/main/files/sshd_config
systemctl restart ssh
systemctl restart sshd
echo "We enabled root login and password auth"
echo "Lets setup a password!"
sudo passwd
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X
iptables-save > /etc/iptables/rules.v4
apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
apt update
sudo apt -y upgrade
apt-add-repository universe
apt -y install php8.1 php8.1-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip} mariadb-server tar unzip apache2 git redis-server zip certbot libapache2-mod-php 
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
mkdir -p /var/www/pterodactyl
cd /var/www/pterodactyl
curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
tar -xzvf panel.tar.gz
chmod -R 755 storage/* bootstrap/cache/
cp .env.example .env
composer install --no-dev --optimize-autoloader
php artisan key:generate --force
chown -R www-data:www-data /var/www/pterodactyl/*
cd /etc/systemd/system
curl -o pteroq.service https://raw.githubusercontent.com/MythicalNodes/OCI-Installer/main/files/pteroq.service
a2dissite 000-default.conf
cd /etc/apache2/sites-available
curl -o pterodactyl.conf https://raw.githubusercontent.com/MythicalNodes/OCI-Installer/main/files/pterodactyl.conf
sudo systemctl enable --now redis-server
sudo systemctl enable --now pteroq.service
systemctl stop apache2
a2enmod rewrite
a2enmod ssl
sudo ln -s /etc/apache2/sites-available/pterodactyl.conf /etc/apache2/sites-enabled/pterodactyl.conf
systemctl start apache2
echo "Done installing the panel."
echo "You have to go to the pterodactyl docs and do the mysql steps and the crontab"


