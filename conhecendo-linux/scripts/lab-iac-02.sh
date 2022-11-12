#!/bin/bash

verify_root() {
  if [[ $EUID -ne 0 ]]; then
      echo "This script must be run as root" 1>&2
      exit 1
  fi
}

update_server() {
  apt update && apt upgrade -y
}

install_packages() {
  apt install apache2 -y
  apt install unzip -y
}

download_site_dio() {
  cd /tmp || exit
  wget -L https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip
  unzip main.zip
  cd linux-site-dio-main || exit
  mv * /var/www/html/
}

main() {
  verify_root

  echo "Updating server"
  update_server

  echo "Installing packages"
  install_packages

  echo "Downloading DIO site"
  download_site_dio
}

main