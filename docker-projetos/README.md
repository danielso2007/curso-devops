# Docker Projetos

Essa pasta juntou todos os estudos em um único docker.
Para iniciar:

1. Faça a ação do item `DNS local` para acessar as aplicações;
2. Execute o sh `./criar-certificados.sh`, para criar os certificados auto assinados;
3. Execute `./start.sh`;
4. Após subir os containers, executar `./novo-k3s-refazer-token.sh`:
    - Irá parar o container `k3s`;
    - Exibirá o token do `rancher` para criação de novo node;
    - Ajuste o `docker-compose.yml`, conforme ação do item `Incluindo um novo node no rancher do nosso container k3s`
    - O container será reiniciado.
5. No `rancher`, o nosso container `K3s` aparecerá como node no cluster `local`;
6. Continue com as ações abaixo para seguir com as configurações.

# DNS local

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

## Portas

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

# Obter o IP do proxy

```shell
docker inspect <nome_do_container> -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps --filter name=reverse -q)
```
docker inspect rancher-local -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps --filter name=reverse -q)


# Nexus

Para acessar: [nexus.local](https://nexus.local)

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

Para acessar: [jenkins.local](http://jenkins.local)

### Configurando o Sonar Scanner

Acesse as configurações do Jenkins: [jenkins.local/manage/configure](http://jenkins.local/manage/configure).

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

Adicionar: `http://jenkins/sonarqube-webhook/`

# Sonarqube

Acesse o link: [sonar.local](http://sonar.local).

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

Para acessar o Rancher, obter a senha com o comando abaixo (no final da execução do `start.sh` é aberto o browser automaticamente):

```shell
docker compose logs rancher 2>&1 | grep "Bootstrap Password:"

$ rancher-local  | 2024/10/26 21:14:03 [INFO] Bootstrap Password: xxxxxxxx # Automaticamente o shell start.sh abre o rancher
```

Agora acesse [https://rancher.local/dashboard/?setup=xxxxxxxx](https://rancher.local/dashboard/?setup=xxxxxxxx).


# Incluindo um novo node no rancher do nosso container k3s

Depois da primeira execução, é preciso executar o sh `novo-k3s-refazer-token.sh`. Ao executar, o container `k3s` é removido, logo após, é obtido o token no container `rancher` e incluído automaticamente no `K3S_TOKEN` do `docker-compose.yml`. Após isso, um novo node será incluídos no `rancher` no cluster `local`.

### Token para um novo node:

Caso queira obter manualmente:

Execute: `docker compose exec rancher cat /var/lib/rancher/k3s/server/node-token`.

# Novo cluster no rancher

No item anterior, colocamos um agente (node) no rancher. Agora estamos adicionando um cluster no rancher, para isso, foi criado um container `k3s-cluster` configurado para ser um kubernate normal. Para adicionado, seguir os passos abaixo:

- Primeiro precisamos mudar o endereço para um interno do `k3s-cluster`, para isso, execute:
    - Dentro do `k3s-cluster` o comando `telnet rancher 9999`;
    - Irá mostrar o IP do rancher após um erro;
    - Pegue esse IP;
- Acesse o rancher na parte `Global Settings` e `Settings`:
    - No campo `server-url`, troque de `https://rancher.local/` para `https://172.21.0.4`;
    - Esse IP é interno do cluster `k3s-cluster`;
    - **Observação**: isso é porque estamos com estudo e dentro de docker em produção não será assim;
    - Sempre olhe esse campo para futuras modificações.
- Volte para a `home`, clicar em `Import Existing`;
- Escolha `Import any Kubernetes cluster > Generic`;
- Adicione um nome ao cluster: `k3s-cluster`;
- Clique em `create`;
- Será exibido vários ações, neste momento:
    - Copie o endereço do `yaml` apenas, exemplo: `https://172.21.0.4/v3/import/x6mlgc6s87dg2mx6ls2dn.yaml`;
    - Copie o conteúdo e adicione no arquivo `./k3s/yaml/cluster.yaml`;
    - Esse arquivo está como volume do nosso container `k3s-cluster`.
- Agora acesse via `exec` o container `k3s-cluster`;
- Acesse a paster `/opt/yaml`;
- Excecute `kubectl apply -f cluster.yaml` para adicionar o cluster ao rancher;
- Se tudo der certo, será criado um novo cluster no rancher.

## Caso precise examinar o Pod criado

Em alguns caso, pode dar erro e você precise analisar, então abaixo alguns comandos úteis:

Ver todos os pods:
```shell
kubectl get pods --all-namespaces
```

Ver os logs do pod:
```shell
kubectl logs <NOME-DO-POD> -n <NAME-SPACE>
```

## Deletando o pod criado

Se precisar deletar o pod que foi criado o cluster no rancher, execute o comando baixo:
```shell
kubectl delete -f cluster.yaml 
```