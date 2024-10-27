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
echo -e "${LIGHT_BLUE}Criando certificado para o Nexus...${NC}"
rm -rf *.pem
rm -rf *.jks
rm -rf *.der
echo -e "${BROWN_ORANGE}Variáveis para o nexus...${NC}"
export NEXUS_DOMAIN="nexus.local"
export NEXUS_IP_ADDRESS="192.168.0.160"
echo -e "${BROWN_ORANGE}Criando keystore.jks...${NC}"
keytool -genkeypair -keystore keystore.jks -storepass 123456 -keypass 123456 -alias nexus -keyalg RSA -keysize 2048 -validity 5000 -dname "CN=*.${NEXUS_DOMAIN}, OU=Example, O=Sonatype, L=Unspecified, ST=Unspecified, C=BR" -ext "SAN=DNS:${NEXUS_DOMAIN},IP:${NEXUS_IP_ADDRESS}" -ext "BC=ca:true"
echo -e "${BROWN_ORANGE}Dando permissão para keystore.jks...${NC}"
sudo chown 666 keystore.jks
echo -e "${LIGHT_BLUE}Fim certificado para o Nexus...${NC}"