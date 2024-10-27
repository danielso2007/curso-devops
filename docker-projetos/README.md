# Docker Projetos

Essa pasta juntou todos os estudos em um único docker.

### DNS local

Recomendo nomes para facilitar nosso acesso aos containers:

```bash
sudo nano /etc/hosts
```

Edite o arquivo adicionando os nomes:

```bash
127.0.0.1 jenkins.local
127.0.0.1 sonar.local
127.0.0.1 nexus.local
127.0.0.1 k3s.local
127.0.0.1 rancher.local
```

### Portas

| APP | HTTP | HTTPS | OUTRO | DNS |
|---|---|---|---|---|
| Jenkine | X | 9043 | 50000 | jenkins.local |
| SonarQube | 9000 | X | X | sonar.local |
| Nexus | X | 9143 | 8123 | nexus.local |
| K3S | 9280 | 9243 | 6443 | k3s.local |
| Rancher | 9380 | 9343 | X | rancher.local |

Para testar a porta:

```shell
telnet jenkins.local 9043
```

# Nexus

Para acessar: [nexus.local:9143/](https://nexus.local:8094/)

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

Para acessar: [jenkins.local:9043/](http://jenkins.local:9043/)

### Configurando o Sonar Scanner

Acesse as configurações do Jenkins: [jenkins.local:9043/manage/configure](http://jenkins.local:9090/manage/configure).

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

Ir em [jenkins.local:9043/manage/configureTools](http://jenkins.local:9043/manage/configureTools/). Acessar: SonarQube Scanner instalações.

Ir até o título `SonarQube Scanner instalações`:
- Name: sonar-scanner
- Não instalar automaticamente
- SONAR_RUNNER_HOME: `/opt/sonar-scanner`

### Associado ao projeto jenkins - Docker SonarQube

Para retonar o resultado para o jenkins, configurar o Webhooks lá no sonarQube: [sonar.local:9000/admin/webhooks](http://sonar.local:9000/admin/webhooks)

Adicionar: `http://jenkins:9043/sonarqube-webhook/`

# Sonarqube

Acesse o link: [sonar.local:9000/](http://sonar.local:9000/).

Na primeira instalação, o login e senha são `admin`.

Para que o sonar retorne o resultado para o Jenkins, ver o item **Associado ao projeto jenkins - Docker SonarQube**.

# K3s - Kubernete

Documentação: [docs.k3s.io/quick-start](https://docs.k3s.io/quick-start).

Caso desejar acessando o container:
```shell
docker compose exec k3s sh
```

Listar todos os Pods:

```shell
kubectl get pods --all-namespaces
```

# Rancher

Temos um container `rancher` apenas para estudo, pois já instalamos um kubernate `K3s` anteriormente. 

Para acessar o Rancher, obter a senha com o comando abaixo:

```shell
docker compose logs rancher 2>&1 | grep "Bootstrap Password:"

$ rancher-local  | 2024/10/26 21:14:03 [INFO] Bootstrap Password: xxxxxxxx
```
Agora acesse [https://rancher.local:9343/](https://rancher.local:9343/).

## Incluindo um novo cluster do nosso container k3s

Como estamos em estudo de kubernete e Rancher, vamos adicionar um novo cluster para usarmos o nosso container `k3s` criado no nosso `docker compose`. A ideia aqui é possibilitar a criação de clusters para ambientes diferentes.



container-k3s
Cluster do container k3s

```shell
curl --insecure -fL https://rancher:443/system-agent-install.sh | sudo  sh -s - --server https://rancher:443 --label 'cattle.io/os=linux' --token xxxxx --ca-checksum xxxx --etcd --controlplane --worker
```

docker compose stop k3s
docker compose rm k3s
docker volume rm docker-projetos_k3s-config docker-projetos_k3s-data
docker compose up -d
sudo apt-get install xclip
Obter o token no rancher: cat /var/lib/rancher/k3s/server/node-token
trocar no docker compose K3S_TOKEN do docker k3s


CATTLE_AGENT_BINARY_BASE_URL="https://172.21.0.3/assets" CATTLE_SERVER="https://172.21.0.3" curl --insecure -fL https://172.21.0.3/system-agent-install.sh | CATTLE_AGENT_BINARY_BASE_URL="https://172.21.0.3/assets" CATTLE_SERVER="https://172.21.0.3" sh -s - --server https://172.21.0.3 --label 'cattle.io/os=linux' --token bv8d5mv5nkr4mfnzbrnqgdqj6n8phr8f796nr7r4v4qql68m6g9hvs --ca-checksum 7637bc252fea071f9db903c822fdfc96aff98632cab36b21fd7ffc18513c0c06 --etcd --controlplane --worker
Trocar o CN para o ip interno do docker do racnher
rancher/ssl/criar_rancher_pem.sh


```shell
kubectl delete pod curl                                                                                                # Deletando se necessário
kubectl run curl --image=curlimages/curl --overrides='{"spec": {"securityContext": {"runAsUser": 0}}}' -i --tty -- sh  # Instalando a imagem do curl
apk add openssl                                                                                                        # Instalar o openssl
```

Se precisar entrar depois:

```shell
kubectl exec -it curl -- /bin/sh
```

curl -k https://172.21.0.3/cacerts


export DEBUG=1

export CATTLE_AGENT_BINARY_BASE_URL="https://172.21.0.3/assets"
export CATTLE_SERVER="https://172.21.0.3/"

curl curl --insecure -fL https://172.21.0.3/system-agent-install.sh > system-agent-install.sh


CATTLE_AGENT_BINARY_BASE_URL="https://172.21.0.3/assets" CATTLE_SERVER="https://172.21.0.3" curl --insecure -fL https://172.21.0.3/system-agent-install.sh | CATTLE_AGENT_BINARY_BASE_URL="https://172.21.0.3/assets" CATTLE_SERVER="https://172.21.0.3" sh -s - --server https://172.21.0.3 --label 'cattle.io/os=linux' --token bv8d5mv5nkr4mfnzbrnqgdqj6n8phr8f796nr7r4v4qql68m6g9hvs --ca-checksum 7637bc252fea071f9db903c822fdfc96aff98632cab36b21fd7ffc18513c0c06 --etcd --controlplane --worker

609

curl curl --insecure -fL https://172.21.0.3/system-agent-install.sh > arquivo.txt

curl curl --insecure -fL https://rancher.local:9343/system-agent-install.sh > arquivo.txt

openssl s_client -connect 172.21.0.3:443 -showcerts </dev/null 2>/dev/null | openssl x509 -outform PEM > certificado.pem
cp certificado.pem /etc/ssl/certs/
export CURL_CA_BUNDLE=certificado.pem

curl --cacert certificado.pem https://172.21.0.3