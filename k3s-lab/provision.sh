#!/usr/bin/env bash

# Montandos as variáveis
export DEBIAN_FRONTEND=noninteractive
export KUBECONFIG=/etc/kubernetes/admin.conf
export KUBELET_EXTRA_ARGS="--container-runtime=docker"
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml 

echo "export DEBIAN_FRONTEND=noninteractive" >> /etc/profile.d/kube_variables.sh
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/profile.d/kube_variables.sh
echo "export KUBELET_EXTRA_ARGS="--container-runtime=docker"" >> /etc/profile.d/kube_variables.sh
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> /etc/profile.d/kube_variables.sh

echo "export DEBIAN_FRONTEND=noninteractive" >> ${HOME}/.bashrc
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ${HOME}/.bashrc
echo "export KUBELET_EXTRA_ARGS="--container-runtime=docker"" >> ${HOME}/.bashrc
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ${HOME}/.bashrc

# Update do sistema
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
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock

# Instalar kubeadm, kubelet, kubectl
curl -sfL https://get.k3s.io | sh -s - --cluster-init --tls-san 192.168.56.150 --node-ip 192.168.56.150 --node-external-ip 192.168.56.150

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml && sudo chmod -R 600 /etc/rancher/k3s/k3s.yaml
# Reiniciando o K3s
sudo systemctl restart k3s

# Vendo os PODs instalados
kubectl get pods --all-namespaces

# Instalando o autocomplete
sudo apt-get install bash-completion -y
sudo echo 'source <(kubectl completion bash)' >>~/.bashrc
sudo echo 'alias k=kubectl' >>~/.bashrc
sudo echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
source ~/.bashrc

# Testando o K do Kubectl instalado acima
k get pods --all-namespaces

# Obtendo o certificado do nexus, nosso registry
openssl s_client -connect 192.168.0.160:8094 -showcerts </dev/null 2>/dev/null | openssl x509 -outform PEM > /etc/rancher/k3s/nexus-cert.pem
sudo cp /etc/rancher/k3s/nexus-cert.pem /usr/local/share/ca-certificates/nexus-cert.crt
sudo update-ca-certificates

# O ip 192.168.0.160 é da minha máquina externa.
sudo echo > /etc/rancher/k3s/registries.yaml
cat <<EOT >> /etc/rancher/k3s/registries.yaml
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

# Install Helm
sudo curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install -y helm
helm version

# Instalando o cert-manager para o Rancher
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml && sudo chmod -R 600 /etc/rancher/k3s/k3s.yaml
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.1/cert-manager.crds.yaml
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io --force-update
helm repo update
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml && sudo chmod -R 600 /etc/rancher/k3s/k3s.yaml
helm install cert-manager --namespace cert-manager --version v1.16.1 jetstack/cert-manager

# Listando os PODs
kubectl get pods --namespace cert-manager

# Instalando o Rancher
helm repo add rancher-latest https://releases.rancher.com/server-charts/stable
helm repo update
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml && sudo chmod -R 600 /etc/rancher/k3s/k3s.yaml
kubectl create namespace cattle-system
helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=rancher.local.org --set bootstrapPassword=admin --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=mail@local.org --set letsEncrypt.ingress.class=nginx --set replicas=1

# Listando os PODs
k get pods --all-namespaces

# Senha do rancher
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{ "\n" }}'
echo https://rancher.local.org/dashboard/?setup=$(kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{ "\n" }}')