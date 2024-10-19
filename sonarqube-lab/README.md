# Sonarqube

Link da documentação: [docs.sonarsource.com](https://docs.sonarsource.com/sonarqube/10.4/setup-and-upgrade/overview/)

Acesse o link: [localhost:9000](http://localhost:9000/sessions/new?return_to=%2F).

Na primeira instalação, o login e senha são `admin`.

## Associado ao projeto jenkins

Tem o próximo estudo que conecta o jenkins ao sonar. Para testar a comunicação interna, usar: `telnet 192.168.56.5 8080`

Para retonar o resultado para o jenkins, configurar o Webhooks:

`Administration > Configuration > Webhooks > Create` e a URL deve apontar para o seu servidor Jenkins `http://{JENKINS_HOST}/sonarqube-webhook/`

Exemplo: `http://192.168.56.5:8080/sonarqube-webhook/`

# Docker Compose

Para executar o SonarQube no docker:

Subir os containers:
```shell
./start.sh
```

Parar os container:
```shell
./stop.sh
```

Remover os container e volumes:
```shell
./remove.sh
```

Entrar no container:
```shell
./exec.sh
```

# Subindo as métricas no SonarQube

Primeiro criar um projeto no sonar e opter o login/token.

No projeto `redis-app`, ajustar o `sonar-project.properties` com o token criado no sonar:

```properties
sonar.login=sqp_b40eff010e8bb7a13abac88cd38db3efc7080b2d
```

Executar nas pasta do projeto o `npm` e o `sonar-scanner` (instalado via npm):

```shell
npm i
nom run sonar
```

Dando tudo certo, só verificar o sonar [localhost:9000/dashboard](http://localhost:9000/dashboard?id=redis-app&selectedTutorial=local)