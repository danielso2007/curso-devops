#!/bin/bash
RED='\033[1;31m'
BLACK='\033[0;30m'
DARK_GRAY='\033[1;30m'
LIGHT_RED='\033[0;31m'
GREEN='\033[0;32m'
LIGHT_GREEN='\033[1;32m'
BROWN_ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
LIGHT_BLUE='\033[1;34m'
PURPLE='\033[0;35m'
LIGHT_PURPLE='\033[1;35m'
CYAN='\033[0;36m'
LIGHT_CYAN='\033[1;36m'
LIGHT_GRAY='\033[0;37m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
echo -e "${LIGHT_BLUE}Criando certificado para o Jenkins...${NC}"
rm -rf *.pem
rm -rf *.jks
rm -rf *.der
rm -rf *.crt
rm -rf *.key
rm -rf *.pfx
echo -e "${BROWN_ORANGE}Criando key-jenkins-privada.key...${NC}"
openssl genpkey -algorithm RSA -out key-jenkins-privada.key
echo -e "${BROWN_ORANGE}Criando certificado-jenkins.crt...${NC}"
openssl req -new -x509 -key key-jenkins-privada.key -out certificado-jenkins.crt -days 365 -subj "/C=BR/ST=SaoPaulo/L=SaoPaulo/O=MinhaEmpresa/OU=TI/CN=jenkins.local" -passout pass:123456
echo -e "${BROWN_ORANGE}Criando certificado-jenkins.pfx...${NC}"
openssl pkcs12 -export -out certificado-jenkins.pfx -inkey key-jenkins-privada.key -in certificado-jenkins.crt -passin pass:123456 -passout pass:123456
echo -e "${BROWN_ORANGE}Criando keystore.jks...${NC}"
keytool -importkeystore -storepass 123456 -keypass 123456 -srckeystore certificado-jenkins.pfx -srcstoretype pkcs12 -destkeystore keystore.jks -deststoretype JKS
echo -e "${BROWN_ORANGE}Permissão keystore.jks...${NC}"
sudo chown 666 keystore.jks