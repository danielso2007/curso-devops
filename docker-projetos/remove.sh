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
echo -e "${BROWN_ORANGE}Parando projeto...${NC}"
docker compose stop
echo -e "${BROWN_ORANGE}Removendo docker...${NC}"
yes | docker compose rm
docker ps -a
# Pergunta ao usuário
echo -e "${LIGHT_RED}Deseja remover os volumes? (sim/não)${NC}"
read resposta
# Verifica a resposta e executa a ação correspondente
if [[ "$resposta" == *"sim"* || "$resposta" == *"s"* ]]; then
    echo -e "${BROWN_ORANGE}Removendo volumes...${NC}"
    # Remove a pasta recursivamente
    docker volume rm docker-projetos_rancher-data docker-projetos_k3s-config docker-projetos_k3s-data docker-projetos_nexus-data docker-projetos_postgresql docker-projetos_postgresql_data docker-projetos_sonarqube_data docker-projetos_sonarqube_extensions docker-projetos_sonarqube_logs
    sudo rm -rf ./k3s/output
    docker volume prune
    docker volume ls
fi