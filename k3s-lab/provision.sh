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

# Obtendo o certificado do nexus, nosso registry
openssl s_client -connect 192.168.0.160:8094 -showcerts </dev/null 2>/dev/null | openssl x509 -outform PEM > /etc/rancher/k3s/exus-cert.pem
sudo cp /etc/rancher/k3s/nexus-cert.pem /usr/local/share/ca-certificates/nexus-cert.crt
sudo update-ca-certificates

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
      cert_file: /etc/rancher/k3s/nexus-cert.pem
      insecure_skip_verify: true
EOT

curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectlecho https://rancher.local.org/dashboard/?setup=$(kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{ "\n" }}')
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.11.01

kubectl get pods --namespace cert-manager

helm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher.local.org --set bootstrapPassword=admin --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=mail@local.org --set letsEncrypt.ingress.class=nginx --set replicas=1

# Senha do rancher
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{ "\n" }}'

echo https://rancher.local.org/dashboard/?setup=$(kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{ "\n" }}')
