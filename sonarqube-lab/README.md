# Sonarqube

Link da documentação: [docs.sonarsource.com](https://docs.sonarsource.com/sonarqube/10.4/setup-and-upgrade/overview/)

Acesse o link: [localhost:9000](http://localhost:9000/sessions/new?return_to=%2F).

Na primeira instalação, o login e senha são `admin`.

## Associado ao projeto jenkins

Tem o próximo estudo que conecta o jenkins ao sonar. Para testar a comunicação interna, usar: `telnet 192.168.56.5 8080`

Para retonar o resultado para o jenkins, configurar o Webhooks:

`Administration > Configuration > Webhooks > Create` e a URL deve apontar para o seu servidor Jenkins `http://{JENKINS_HOST}/sonarqube-webhook/`

Exemplo: `http://192.168.56.5:8080/sonarqube-webhook/`