#/usr/bin/bash
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
echo -e "${LIGHT_BLUE}Deletando certificados do nexus...${NC}"
cd nexus/ssl
rm -rf *.pem
rm -rf *.jks
rm -rf *.der
rm -rf *.crt
rm -rf *.key
rm -rf *.pfx
rm -rf *.csr
rm -rf *.crl
cd ..
cd ..
echo -e "${LIGHT_BLUE}Deletando certificados do jenkins...${NC}"
cd jenkins/ssl
rm -rf *.pem
rm -rf *.jks
rm -rf *.der
rm -rf *.crt
rm -rf *.key
rm -rf *.pfx
rm -rf *.csr
rm -rf *.srl
cd ..
cd ..
echo -e "${LIGHT_BLUE}Deletando certificados do rancher...${NC}"
cd rancher/ssl
rm -rf *.pem
rm -rf *.jks
rm -rf *.der
rm -rf *.crt
rm -rf *.key
rm -rf *.pfx
rm -rf *.csr
rm -rf *.srl
cd ..
cd ..
