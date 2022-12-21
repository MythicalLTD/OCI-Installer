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
