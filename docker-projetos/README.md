# Docker Projetos

Essa pasta juntou todos os estudos em um único docker.

## DNS local

Recomendo nomes para facilitar nosso acesso aos containers:

```bash
sudo nano /etc/hosts
```

Edite o arquivo adicionando os nomes:

```bash
127.0.0.1 nexus.local
127.0.0.1 jenkins.local
127.0.0.1 sonar.local
192.168.56.150 rancher.local
```

**Observação:** O endereço `rancher.local` é para apontar para o K3s do estudo `k3s-lab`.


# Nexus

Para acessar: [nexus.local:8094/](https://nexus.local:8094/)

Por padrão, o usuário é `admin` e senha é `admin123`.

## Criando usuário para integração com o jenkins

Para a integração com o jenkins, criar um usuário login `jenkins` e senha `jenkins123`. É preciso criar no Jenkins das credenciais, com ID `jenkins-nexus` e usar o login e senha criados no nexus.

## Criar um docker repo

Criar um repositório para as imagens docker (registry docker).

- Repositories
  - docker (hosted)
    - nome: `docker-repo`
    - HTTPS: `8123` | Exposto lá no docker compose

# Jenkins

Inicialmente é gerada uma senha aleatório. Acesse `docker compose logs jenkins` para ver no console a senha.

Para acessar: [jenkins.local:9090/](http://jenkins.local:9090/)

### Configurando o Sonar Scanner

Acesse as configurações do Jenkins: [jenkins.local:9090/manage/configure](http://jenkins.local:9090/manage/configure).

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

Ir em [jenkins.local:9090/manage/configureTools](http://jenkins.local:9090/manage/configureTools/). Acessar: SonarQube Scanner instalações.

Ir até o título `SonarQube Scanner instalações`:
- Name: sonar-scanner
- Não instalar automaticamente
- SONAR_RUNNER_HOME: `/opt/sonar-scanner`

### Associado ao projeto jenkins - Docker SonarQube

Para retonar o resultado para o jenkins, configurar o Webhooks lá no sonarQube: [sonar.local:9000/admin/webhooks](http://sonar.local:9000/admin/webhooks)

Adicionar: `http://jenkins:9090/sonarqube-webhook/`

# Sonarqube

Acesse o link: [sonar.local:9000/](http://sonar.local:9000/).

Na primeira instalação, o login e senha são `admin`.

Para que o sonar retorne o resultado para o Jenkins, ver o item **Associado ao projeto jenkins - Docker SonarQube**.

