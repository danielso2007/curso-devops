#!/usr/bin/env bash
echo "Installing Apache and setting it up..."
apt update -y
apt install apache2 -y
cp -r /vagrant/html/* /var/www/html/
sudo systemctl start apache2
sudo systemctl status apache2
ufw allow http
hostname -I