# OCI-Installer
Some of our installers

Pterodactyl Install Script (panel.mythicalnodes.xyz)

```bash
bash <(curl -s https://raw.githubusercontent.com/MythicalNodes/OCI-Installer/main/panel-install.sh)
```

PhpMyAdmin Install script (phpmyadmin.mythicalnodes.xyz)

```bash
bash <(curl -s https://raw.githubusercontent.com/MythicalNodes/OCI-Installer/main/pma-install.sh)
```

Domain SSL
```bash
certbot -d <domain> --manual --preferred-challenges dns certonly
```