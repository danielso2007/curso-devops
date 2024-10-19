#!/bin/bash
docker compose stop
yes | docker compose rm
docker ps -a
# Pergunta ao usuário
echo "Deseja remover os volumes? (sim/não)"
read resposta

# Verifica a resposta e executa a ação correspondente
if [[ "$resposta" == *"sim"* || "$resposta" == *"s"* ]]; then
    # Remove a pasta recursivamente
    docker volume rm exemplo-docker_jenkins_home
    docker volume ls
fi