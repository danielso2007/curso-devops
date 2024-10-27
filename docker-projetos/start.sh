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
echo -e "${LIGHT_BLUE}Subindo projeto...${NC}"
cd nexus/ssl
./criar_jks_nexus.sh
cd ..
cd ..
cd jenkins/ssl
./criar_jks_jenkins.sh
cd ..
cd ..
cd rancher/ssl
./criar_rancher_pem.sh
cd ..
cd ..
docker compose up -d
docker compose ps
echo -e "${BROWN_ORANGE}Senha do rancher...${NC}"
docker compose logs rancher 2>&1 | grep "Bootstrap Password:"
