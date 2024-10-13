#/bin/sh
cat << EOT >> /home/vagrant/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHxlyJXvUuz4qu1DHBDd4HRQcghhYmX1M6J65w6bEXG2 vagrant@control-node
EOT
cat <<EOT >> /etc/hosts
192.168.56.4 db01
EOT