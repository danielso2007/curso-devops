# Exemplo de docker swarm dentro de um container

Esse exemplo é para caso não queira iniciar um docker swarm em seu docker local. Esse exemplo usar imagen com docker interno, simulando uma máquina `manager`e seus workers.

## Inicinado do docker compose

```shell
docke compose -d
```


## Iniciando swarm

**Caso precise encerrar o swarm (devido ao volume criado pode já tá em execução)**:
```shell
docker exec -it manager docker swarm leave --force
```

Inicinado o docker swarm:

```shell
docker exec -it manager docker swarm init --advertise-addr 172.22.0.2
```

Exibindo os nós:
```shell
docker exec -it manager docker node ls
```

Obter o token para ser incluídos nos workers:
```shell
docker exec -it manager docker swarm join-token worker
```

Com o token obtido acima, adicionar os workers 1 e 2:
```shell
docker exec -it worker1 docker swarm join --token SWMTKN-1-14bd2dxtldw45y2iy4isgeqyqmds7mci95r175n34n31aa1e1h-be33csn7bse5xuaa8im3ngehh manager:2377
```
```shell
docker exec -it worker2 docker swarm join --token SWMTKN-1-14bd2dxtldw45y2iy4isgeqyqmds7mci95r175n34n31aa1e1h-be33csn7bse5xuaa8im3ngehh manager:2377
```

## Subindo o primero serviço

Estamos subindo um container nginx. Esse docker compose já sobre com 3 réplicas e para nós da role `constraints: [node.role == manager]`
```shell
docker exec -it manager docker stack deploy -c /home/docker-compose.yml stack-nginx
```

## Outros comandos

Listar os serviços:
```shell
docker exec -it manager docker service ls
```

Mais detalhe do serviço criado acima:
```shell
docker exec -it manager docker service ps stack-nginx_nginx
```

Escalando a stack com para 5:
```shell
docker exec -it manager docker service scale stack-nginx_nginx=5
```

Verificando os containers de cada máquina. Neste caso, a `manager` não tem serviço único.
```shell
docker exec -it manager docker ps
docker exec -it worker1 docker ps
docker exec -it worker2 docker ps
```

Caso precise atualizar o serviço
```shell
docker exec -it manager docker service update stack-nginx_nginx
```