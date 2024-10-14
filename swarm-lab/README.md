# Inicinado o estudo

Executar o vagrant para montar as máquinas. Usar a Task `Vagrant UP`, ou executar:

```shell
vagrant up
```

Verificar se o docker foi instalado, usar a task `Manager | Vagrant SSH` ou:

```shell
vagrant ssh manager
```

```shell
docker
```

## Iniciar o swarm no manager

```shell
vagrant ssh manager
```

```shell
docker swarm init --advertise-addr 192.168.56.2
```

**Saída do terminal**:
```shell
docker swarm join --token <TOKEN> 192.168.56.2:2377
```
## Obter o token do comando acima

Entrar em cada worker e executar:

```shell
docker swarm join --token <TOKEN> 192.168.56.2:2377
```

## Verificar nós ativos

No manager:

```shell
docker node ls
```

## Iniciando serviços

Abaixo, criando uma imagem do nginx, mas pode ser criado um via `docker compose`, exemplo: `docker stack deploy -c docker-compose.yml mystack`.

```shell
docker service create --name demo --publish 80:80 nginx
```

Para listar os serviços:

```shell
docker service ls
```

Mais detalhes:

```shell
docker service ps demo
```

## Scale

Subindo em outros workers:

```shell
docker service scale demo=3
```

## Teste dentro do manager

```shell
curl http://192.168.56.2
curl http://192.168.56.3
curl http://192.168.56.4
```
