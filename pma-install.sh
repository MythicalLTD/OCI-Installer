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
cd /var/www
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip
unzip phpMyAdmin-5.2.0-all-languages.zip
mv phpMyAdmin-5.2.0-all-languages pma
cd pma
curl -o config.inc.php https://raw.githubusercontent.com/MythicalNodes/OCI-Installer/main/files/config.inc.php
cd themes
wget https://files.phpmyadmin.net/themes/darkwolf/5.2/darkwolf-5.2.zip
unzip darkwolf-5.2.zip
cd /var/www/pma
mkdir tmp
chmod 777 tmp
cd /etc/apache2/sites-available
curl -o pma.conf https://raw.githubusercontent.com/MythicalNodes/OCI-Installer/main/files/pma.conf
sudo ln -s /etc/apache2/sites-available/pma.conf /etc/apache2/sites-enabled/pma.conf
echo "DONT FORGET TO CHANGE THE BLOWFISH IN /var/www/pma"
