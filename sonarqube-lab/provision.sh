#/usr/bin/bash
# Apenas para tirar aviso de erro
export DEBIAN_FRONTEND=noninteractive

export SONAR_VERSION=sonarqube-10.7.0.96327
export JAVA_INSTALL_VERSION=openjdk-17-jdk
export SONAR_LOCAL=/opt/sonarqube

sudo useradd sonar
sudo groupadd sonar

sudo apt-get -qq update
sudo apt-get -qq install wget unzip ${JAVA_INSTALL_VERSION} -y 
sudo wget -q https://binaries.sonarsource.com/Distribution/sonarqube/${SONAR_VERSION}.zip
sudo unzip -q ${SONAR_VERSION}.zip -d /opt/

sudo mv /opt/${SONAR_VERSION} ${SONAR_LOCAL}
sudo useradd -d ${SONAR_LOCAL} -g sonar sonar
sudo chown -R sonar:sonar ${SONAR_LOCAL}

sudo touch /etc/systemd/system/sonar.service
sudo chmod 666 /etc/systemd/system/sonar.service
sudo echo > /etc/systemd/system/sonar.service
cat <<EOT >> /etc/systemd/system/sonar.service
[Unit]
Description=SonarQube service
After=syslog.target network.target
[Service]
Type=forking
User=sonar
Group=sonar
ExecStart=${SONAR_LOCAL}/bin/linux-x86-64/sonar.sh start
ExecStop=${SONAR_LOCAL}/bin/linux-x86-64/sonar.sh stop
StandardOutput=journal
LimitNOFILE=131072
LimitNPROC=8192
TimeoutStartSec=5
Restart=always
SuccessExitStatus=143
[Install]
WantedBy=multi-user.target
EOT
sudo systemctl daemon-reload
sudo systemctl enable sonar
sudo systemctl start sonar

# Instalando o NodeJs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
source ~/.bashrc
nvm install --lts

sudo wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-6.2.1.4610-linux-x64.zip
sudo unzip -qo sonar-scanner-cli-6.2.1.4610-linux-x64.zip -d /opt/
sudo mv /opt/sonar-scanner-6.2.1.4610-linux-x64 /opt/sonar-scanner
sudo chown -R sonar:sonar /opt/sonar-scanner
sudo echo 'export PATH=$PATH:/opt/sonar-scanner/bin' | sudo tee -a /etc/profile
sudo echo "export PATH=$PATH:/opt/sonar-scanner/bin" >> ~/.bashrc
sudo echo "export SONAR_SCANNER_HOME=/opt/sonar-scanner" >> ~/.bashrc
source ~/.bashrc


# Exibindo as versões sqp_5567adb777bda0e88659140e7bc269cf98e08873
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
sudo systemctl is-active sonar