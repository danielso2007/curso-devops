# Jenkins e docker

A senha aparece no console do docker. Será preciso para iniciar o jenkins.

Para executar no docker:

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

## Configurando o Sonar Scanner

É preciso que o docker do sonarQube do estudo anterior, também esteja sendo executado em docker.

Acesse as configurações do Jenkins: [localhost:9090/manage/configure](http://localhost:9090/manage/configure).

- `Environment variables` = check true
- Add SonarQube
- Name: sonar-sever
- Server URL: http:sonarqube:9000
- Add Server authentication token --> Criar lá no sonar
  - Kind: `Secret text`
  - Secret: adicionar o token criado no Sonar
  - ID: secret-sonar

### Configurar o tools

Ir em `Painel de controle > Gerenciar Jenkins > Tools`. Acessar: SonarQube Scanner instalações.

- Name: sonar-scanner
- Não instalar automaticamente
- SONAR_RUNNER_HOME: `/opt/sonar-scanner`

## Associado ao projeto jenkins - Docker Sonar

Tem o próximo estudo que conecta o jenkins ao sonar. Para testar a comunicação interna, usar: `telnet jenkins 9090`

Para retonar o resultado para o jenkins, configurar o Webhooks:

`Administration > Configuration > Webhooks > Create` e a URL deve apontar para o seu servidor Jenkins `http://{JENKINS_HOST}/sonarqube-webhook/`

Exemplo: `http://jenkins:9090/sonarqube-webhook/`
