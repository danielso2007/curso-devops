FROM ubuntu:bionic-20230530
USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update
RUN apt-get upgrade -y
RUN apt-get -qq install wget unzip curl telnet net-tools gnupg2 software-properties-common systemd
RUN apt-get update && apt-get install -y -q --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        libssl-dev \
        wget \
    && rm -rf /var/lib/apt/lists/*
# Desabilitar swap (necessário para o Kubernetes)
# RUN swapoff -a
RUN sed -i '/ swap / s/^/#/' /etc/fstab
# Instalar Docker
RUN apt-get -y install ca-certificates curl unzip telnet net-tools
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
RUN chmod a+r /etc/apt/keyrings/docker.asc
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Instalar kubeadm, kubelet, kubectl
RUN curl -sfL https://get.k3s.io | sh -s - --tls-san 127.0.0.1 --node-ip 127.0.0.10 --node-external-ip 127.0.0.1
RUN chmod -R 600 /etc/rancher/k3s/k3s.yaml
# Instalando o autocomplete
RUN apt-get install bash-completion -y
RUN echo 'source <(kubectl completion bash)' >>~/.bashrc
RUN echo 'alias k=kubectl' >>~/.bashrc
RUN echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
RUN source ~/.bashrc
# Install Helm
RUN curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
RUN apt-get install apt-transport-https --yes
RUN "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
RUN apt-get update
RUN apt-get install -y helm
RUN helm version
# Instalando o cert-manager para o Rancher
RUN kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.1/cert-manager.crds.yaml
RUN kubectl create namespace cert-manager
RUN helm repo add jetstack https://charts.jetstack.io --force-update
RUN helm repo update
RUN helm install cert-manager --namespace cert-manager --version v1.16.1 jetstack/cert-manager
# Instalando o Rancher
RUN helm repo add rancher-latest https://releases.rancher.com/server-charts/stable
RUN helm repo update
RUN kubectl create namespace cattle-system
RUN helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=rancher.local.org --set bootstrapPassword=admin --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=mail@local.org --set letsEncrypt.ingress.class=nginx --set replicas=1
# Senha do rancher
RUN kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{ "\n" }}'
RUN echo https://rancher.local.org/dashboard/?setup=$(kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{ "\n" }}')




k3s:
    build:
      context: .
      dockerfile: ./k3s/Dockerfile
    image: local/k3s:latest
    container_name: k3s-local
    privileged: true
    environment:
      - KUBECONFIG=/etc/kubernetes/admin.conf
      - KUBELET_EXTRA_ARGS="--container-runtime=docker"
      - KUBECONFIG=/etc/rancher/k3s/k3s.yaml
    volumes:
      - k3s-data:/var/lib/rancher/k3s
      - k3s-config:/etc/rancher/k3s
      - ./k3s/output:/output
    ports:
      - "6443:6443"  # Porta padrão de API do Kubernetes
      - "80:80"      # Exemplo de porta para expor serviços
      - "443:443"    # Exemplo de porta HTTPS para expor serviços
    command:
      - server
      - --cluster-init
    depends_on:
      - sonarqube
      - jenkins
      - nexus