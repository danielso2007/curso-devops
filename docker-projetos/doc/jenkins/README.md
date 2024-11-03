## Índice

* [Start do projeto](#start-do-projeto)
* [Iniciando](#iniciando)
* [Reiniciando o k3s-local](#reiniciando-o-k3s-local)
* [Acessando o Rancher](#acessando-o-rancher)
* [Confirmação da subida do k3s-local como node do Rancher](#confirmação-da-subida-do-k3s-local-como-node-do-rancher)

[Voltar](../../README.md)

# Jenkins

Inicialmente é gerada uma senha aleatório. Acesse `docker compose logs jenkins` para ver no console a senha. Também podemos obter a senha por `docker compose exec -it jenkins cat /var/lib/jenkins/secrets/initialAdminPassword`.

Para acessar: [jenkins.local](http://jenkins.local)

### Configurando o Sonar Scanner

Acesse as configurações do Jenkins: [jenkins.local/manage/configure](http://jenkins.local/manage/configure). É preciso criar um usuário para o jenkins no sonar e obter a `secret`.

Ir até o título `SonarQube servers`:
- `Environment variables` = check true
- Add SonarQube
- Name: sonar-sever
- Server URL: http:sonarqube:9000
- Add Server authentication token --> Criar lá no sonar
  - Kind: `Secret text`
  - Secret: adicionar o token criado no Sonar
  - ID: secret-sonar

### Configurar o tools

Ir em [jenkins.local/manage/configureTools](http://jenkins.local/manage/configureTools/). Acessar: SonarQube Scanner instalações.

Ir até o título `SonarQube Scanner instalações`:
- Name: sonar-scanner
- Não instalar automaticamente
- SONAR_RUNNER_HOME: `/opt/sonar-scanner`

### Associado ao projeto jenkins - Docker SonarQube

Para retonar o resultado para o jenkins, configurar o Webhooks lá no sonarQube: [sonar.local/admin/webhooks](http://sonar.local/admin/webhooks)

Adicionar: `https://jenkins:8443/sonarqube-webhook/`

### Acessando o registry docker / images

Criar uma variável global (`https://jenkins.local/manage/configure`) no jenkins: `NEXUS_URL=localhost:8123`.
É preciso criar um usuário no jenkins para acessar o nexus. Em `https://jenkins.local/manage/credentials/store/system/domain/_/`, criado no item "Criando usuário para integração com o jenkins":

- Username: `jenkins`
- Password: `jenkins123`
- ID: `jenkins-nexus`

---
[Voltar](../../README.md)