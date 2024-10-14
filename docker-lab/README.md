# Estudo simples do docker

Não será usado o vagrant, é preciso ter o docker instalado na máquina linux. Esse projeto foi feito no ubuntu 24.04.

## Instalando o docker no ubuntu

Acessar o link [docs.docker.com/engine/install/ubuntu](https://docs.docker.com/engine/install/ubuntu/).

# Exemplo aplicação Java

## Executando o spring-boot "notes"

Criar usando o comando abaixo:

```shell
docker build -t devops/notes .
```

O Dockerfile é para uma aplicação Java. Essa imagem ficou grande, pois todos os comandos são executados.

## Reduzindo a imagem docker acima

Foi criado o `DockerfileStage`.

Esse novo, agora salvamos as dependências `.m2` em volume.

```shell
docker build -f DockerfileStage -t devops/notes:1.0.0 . --no-cache
```

Teoricamente, essa imagem ficou menor. Foi usado o conceito de [multi-stage](https://docs.docker.com/build/building/multi-stage/) docker.

# Exemplo nodejs

Primeiramente, criar o `network`: 

```shell
docker network create devops
```

Para executar, usar os comandos abaixo os as tasks criadas no `.vscode`.

Crie o container do `redis`:

```shell
docker run --net devops --name redis-server -d redis
```

Criar a imagem do projeto nodejs:

```shell
cd node-app-exemplo && docker build -t devops/node-app:1.0.0 .
```

Subir o projeto e expor a porta `8081`:

```shell
cd node-app-exemplo && docker run --net devops --name node-app -d -p 8081:3000 devops/node-app:1.0.0
```

Apagar a imagem, caso precise:
```shell
docker stop node-app && docker rm node-app && docker image rm devops/node-app:1.0.0
```

Testando a chamada:

```shell
curl http://localhost:8081/contador
```

# Exemplo docker compose

Na pasta `docker-compose`, tem o exemplo anterior funcionando. Execute `docker compose up` e veja a aplicação funcionando.

Testando a chamada:

```shell
curl http://localhost:8081/contador
```

