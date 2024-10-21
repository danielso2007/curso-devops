#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
export KUBECONFIG=/etc/kubernetes/admin.conf
export KUBELET_EXTRA_ARGS="--container-runtime=docker"

sudo apt-get update
sudo apt-get upgrade -y

# Desabilitar swap (necessário para o Kubernetes)
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Instalar Docker
sudo apt-get -y install ca-certificates curl unzip telnet net-tools
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock

# Instalar kubeadm, kubelet, kubectl
curl -sfL https://get.k3s.io | sh -s - --cluster-init --tls-san 192.168.56.150 --node-ip 192.168.56.150 --node-external-ip 192.168.56.150

sudo apt-get install bash-completion -y
sudo echo 'source <(kubectl completion bash)' >>~/.bashrc
sudo echo 'alias k=kubectl' >>~/.bashrc
sudo echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
source ~/.bashrc

# O ip 192.168.0.160 é da minha máquina externa.
sudo echo > /etc/rancher/k3s/registries.yaml
cat <<EOT >> /etc/rancher/k3s/registries.yaml
mirrors:
  docker.io:
    endpoint:
      - https://192.168.0.160:8094
configs:
  192.168.0.160:8094:
    auth:
      username: jenkins
      password: jenkins123
  "*":
    tls:
      insecure_skip_verify: true
EOT

sudo docker run --privileged -d --restart=unless-stopped -p 8888:80 -p 4444:443 rancher/rancher