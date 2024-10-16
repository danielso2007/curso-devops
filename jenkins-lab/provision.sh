#/bin/bash

# Apenas para tirar aviso de erro
export DEBIAN_FRONTEND=noninteractive

export JAVA_INSTALL_VERSION=openjdk-17-jre
export NVM_VERSION=0.40.1

# Instalação commons
sudo apt-get install epel-release -y
sudo apt-get install wget git -y
sudo apt-get install rpm -y

# Instalando o Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get -qq update
sudo apt-get -qq install jenkins -y

# Instalando o Java 17
sudo apt-get -qq update
sudo apt-get -qq install fontconfig ${JAVA_INSTALL_VERSION} -y
java -version

# Inicinado o serviço do jenkins
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Instalacao do docker e docker compose
sudo apt-get -qq update
sudo apt-get -qq -y install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -qq update
sudo apt-get -qq -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock
sudo usermod -aG docker jenkins

# Instalacao do sonar scanner
export SONAR_SCANNER_VERSION=sonar-scanner-cli-6.2.1.4610-linux-x64
export SONAR_SCANNER_LOCAL=/opt/sonar-scanner

sudo apt-get -qq install wget unzip -y
sudo wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-6.2.1.4610-linux-x64.zip
sudo unzip -qo sonar-scanner-cli-6.2.1.4610-linux-x64.zip -d /opt/
sudo mv /opt/sonar-scanner-6.2.1.4610-linux-x64 /opt/sonar-scanner
sudo chown -R jenkins:jenkins /opt/sonar-scanner
sudo echo 'export PATH=$PATH:/opt/sonar-scanner/bin' | sudo tee -a /etc/profile
sudo echo "export PATH=$PATH:/opt/sonar-scanner/bin" >> ~/.bashrc
sudo echo "export SONAR_SCANNER_HOME=/opt/sonar-scanner" >> ~/.bashrc
source ~/.bashrc

# Instalando o NodeJs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
source ~/.bashrc
nvm install --lts

# Exibindo as versões
echo
echo ==== Sonar-Scanner version ==== 
sonar-scanner -v

echo
echo ==== Java version ==== 
java --version

echo
echo ==== NodeJs version ==== 
node --version

echo
echo ==== Sonar version ==== 
sudo systemctl is-active jenkins

echo
echo ==== Senha do administrador ==== 
sudo cat /var/lib/jenkins/secrets/initialAdminPassword