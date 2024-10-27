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
echo -e "${LIGHT_BLUE}Criando certificado para o Rancher...${NC}"
rm -rf *.pem
rm -rf *.jks
rm -rf *.der
rm -rf *.crt
rm -rf *.key
rm -rf *.pfx
echo -e "${BROWN_ORANGE}Criando key.pem e cert.pem...${NC}"
openssl genpkey -algorithm RSA -out key-rancher-privada.key -pkeyopt rsa_keygen_bits:2048
openssl rsa -in key-rancher-privada.key -text > key.pem
openssl req -new -x509 -key key-rancher-privada.key -nodes -days 365 -subj "/C=BR/ST=SaoPaulo/L=SaoPaulo/O=MinhaEmpresa/OU=TI/CN=172.21.0.3" -passin pass:123456 -passout pass:123456 -out cert.pem
openssl req -new -x509 -key key-rancher-privada.key -days 365 -subj "/C=BR/ST=SaoPaulo/L=SaoPaulo/O=MinhaEmpresa/OU=TI/CN=172.21.0.3" -passin pass:123456 -passout pass:123456 -out cacerts.pem
sudo chown 666 key-rancher-privada.key
sudo chown 666 cert.pem
sudo chown 666 cacerts.pem
echo -e "${LIGHT_BLUE}Fim certificado para o Rancher...${NC}"