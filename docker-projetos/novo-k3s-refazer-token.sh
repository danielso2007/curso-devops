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
echo -e "${LIGHT_BLUE}Instalando o xclip...${NC}"
sudo apt-get install xclip
echo -e "${LIGHT_BLUE}Refazendo o container K3S...${NC}"
docker compose stop k3s
docker compose rm k3s
docker volume rm docker-projetos_k3s-config docker-projetos_k3s-data
echo -e "${LIGHT_BLUE}Obter o token do rancher e ajustar K3S_TOKEN no docker-compose-yaml...${NC}"
docker compose exec rancher cat /var/lib/rancher/k3s/server/node-token
echo -e "${LIGHT_BLUE}Token copiado em memória, só colar no docker-compose.yaml${NC}"
docker compose exec rancher cat /var/lib/rancher/k3s/server/node-token | xclip -selection clipboard
echo -e "${LIGHT_RED}Já substituiu o valor?  (sim/não)${NC}"
read resposta
# Verifica a resposta e executa a ação correspondente
if [[ "$resposta" == *"sim"* || "$resposta" == *"s"* ]]; then
    echo -e "${BROWN_ORANGE}Subindo container K3s...${NC}"
    docker compose up -d
fi