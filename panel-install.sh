#!/bin/bash
set -e
if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi
echo "   Welcome to MythicalNodes Panel Script"
echo "With this script you can setup your server"
echo "         On your ubuntu server"
echo "       Copyright 2022 MythicalNodes"
read -p "Press any key to start installing ..."
cd /etc/ssh
rm sshd_config
curl -o sshd_config https://raw.githubusercontent.com/KoolKid-Development/Easy-Setup/main/Files/sshd_config
systemctl restart ssh
systemctl restart sshd
echo "We enabled root login and password auth"
echo "Lets setup a password!"
sudo passwd
sudo apt update
sudo apt -y upgrade
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X
iptables-save > /etc/iptables/rules.v4
cd /etc/nginx/sites-available
rm default
cd /etc/nginx/sites-enabled
rm default
cd /etc/nginx/sites-available
echo "No the only thing left is the certificate and to start nginx"
echo "Use: certbot certonly --standalone -d yourdomain.com"
echo "And after that systemctl start nginx"
echo "And you are done!"
