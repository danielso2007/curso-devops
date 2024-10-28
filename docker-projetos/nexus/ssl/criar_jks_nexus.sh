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

export OPENSSL_CN="nexus"
export OPENSSL_IP_ADDRESS="192.168.0.160"
export OPENSSL_C=BR
export OPENSSL_ST=SaoPaulo
export OPENSSL_L=SaoPaulo
export OPENSSL_O=MinhaEmpresa
export OPENSSL_OU=TI
export OPENSSL_PASS=123456

# Analisando os argumentos
while getopts ":d:i:s:h" opt; do
  case $opt in
    d)
      OPENSSL_CN="$OPTARG"
      ;;
    i)
      OPENSSL_IP_ADDRESS="$OPTARG"
      ;;
    s)
      OPENSSL_PASS="$OPTARG"
      ;;
    h)
      echo "Uso: $0 [-d domínio] [-i ip do docker] [-s senha do certifdicado]"
      exit 0
      ;;
    \?)
      echo "Opção inválida: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Opção -$OPTARG requer um argumento." >&2
      exit 1
      ;;
  esac
done

openssl req -x509 -nodes -days 5000 -newkey rsa:2048 -keyout key-nexus-privada.key -out certificado-nexus.crt -subj "/C=${OPENSSL_C}/ST=${OPENSSL_ST}/L=${OPENSSL_L}/O=${OPENSSL_O}/OU=${OPENSSL_OU}/CN=${OPENSSL_CN}" -passin pass:${OPENSSL_PASS} -passout pass:${OPENSSL_PASS}
sudo cp certificado-nexus.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates
openssl req -newkey rsa:2048 -nodes -keyout node.key -out node.csr -subj "/C=${OPENSSL_C}/ST=${OPENSSL_ST}/L=${OPENSSL_L}/O=${OPENSSL_O}/OU=${OPENSSL_OU}/CN=${OPENSSL_CN}" -passin pass:${OPENSSL_PASS} -passout pass:${OPENSSL_PASS}

openssl x509 -req -in node.csr -CA certificado-nexus.crt -CAkey key-nexus-privada.key -CAcreateserial -out certificado-nexus.csr -days 5000

openssl pkcs12 -export -out certificado-nexus.pfx -inkey key-nexus-privada.key -in certificado-nexus.crt -passin pass:${OPENSSL_PASS} -passout pass:${OPENSSL_PASS}

keytool -importkeystore -storepass ${OPENSSL_PASS} -keypass ${OPENSSL_PASS} -srckeystore certificado-nexus.pfx -srcstoretype pkcs12 -destkeystore keystore.jks -deststoretype pkcs12 -dname "/C=${OPENSSL_C}/ST=${OPENSSL_ST}/L=${OPENSSL_L}/O=${OPENSSL_O}/OU=${OPENSSL_OU}/CN=${OPENSSL_CN}" -ext "SAN=DNS:${OPENSSL_CN},IP:${OPENSSL_IP_ADDRESS}" -ext "BC=ca:true"
sudo chown 400 keystore.jks

#keytool -genkeypair -keystore keystore.jks -storepass 123456 -keypass 123456 -alias nexus -keyalg RSA -keysize 2048 -validity 5000 -dname "CN=*.${NEXUS_DOMAIN}, OU=Example, O=Sonatype, L=Unspecified, ST=Unspecified, C=BR" -ext "SAN=DNS:${NEXUS_DOMAIN},IP:${NEXUS_IP_ADDRESS}" -ext "BC=ca:true"

rm -rf *.pem
rm -rf *.der
rm -rf *.crt
rm -rf *.key
rm -rf *.pfx
rm -rf *.csr
rm -rf *.srl