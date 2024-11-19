## Índice

* [Introdução](#introducao)
* [Docker Projetos](#docker-projetos)
    * [DNS local](#dns-local)
    * [Portas do network interno docker](#portas-do-network-interno-docker)
    * [Próximos passos](#próximos-passos)
* [Obter o IP do proxy](#obter-o-ip-do-proxy)
* [Configuração Nexus](./doc/nexus/README.md)
* [Configuração Jenkins](./doc/jenkins/README.md)
* [Configuração Sonar](./doc/sonar/README.md)
* [Configuração Kubernate](./doc/k3s/README.md)
* [Configuração Rancher](./doc/rancher/README.md)

## Introdução <a name="introducao"></a>

O objetivo desse projeto e juntar todo o estudo de devOps em containers docker. Os outros projetos de reposiório podem ser estudados separadamente. Um observação importante é que tudo está levando em consideração que o seu sistema operacional é o Ubuntu.

## Docker Projetos <a name="docker-projetos"></a>

Esse projeto usa o nginx para proxy reverso. Todos os containers estão com as portas fechados, só podendo ser acessados por proxy. Abaixo, devemos adicionar o DNS na nossa máquima, para facilitar o acesso aos projetos e estudos.

Um observação inportante é que nem todos os containers estão na mesmo **network do docker**.

Para iniciar, siga os passos abaixo:

1. Faça a ação do item [DNS local](#dns-local) para acessar as aplicações;
2. Execute o sh `./criar-certificados.sh`, para criar os certificados auto assinados;
3. Execute `./start.sh`. No processo, o container k3s será adicionado como node automaticamente. Mas detalhes [aqui](./doc/start/README.md);
4. Será aberto um browser direcionando para o [rancher](https://rancher.local/dashboard/auth/setup);
5. No `rancher`, o nosso container `K3s` aparecerá como node no cluster `local`;
6. Para continuar com as configurações iniciais, seguir os próximos passos.

## Próximos passos <a name="próximos-passos"></a>

Esse são os passos após iniciar o `./start.sh` informado no passo [Docker Projetos](#docker-projetos):

1. Configurar o [nexus](./doc/nexus/README.md);
2. Configurar o [jenkins](./doc/jenkins/README.md);
3. Configurar o [Sonar](./doc/sonar/README.md);
4. Configurar o [Kubernate - k3s](./doc/k3s/README.md);
5. Configurar o [Rancher](./doc/rancher/README.md);


### DNS local <a name="dns-local"></a>

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
127.0.0.1 redis.app
```

### Portas do network interno docker <a name="portas-do-network-interno-docker"></a>

As portas configuradas para as aplicações, podendo ser usadas apenas internamente dentro dos containers de mesmo network.

| APP | HTTP | HTTPS | OUTRO | DNS |
|---|---|---|---|---|
| Nginx | 80 | 443 | X | localhost |
| Jenkine | X | 9043 | 50000 | jenkins.local |
| SonarQube | 9000 | X | X | sonar.local |
| Nexus | X | 9143 | 8123 | nexus.local |
| K3S | 9280 | 9243 | 6443 | k3s.local |
| Rancher | 9380 | 9343 | X | rancher.local |


Para testar a porta:

```shell
telnet jenkins.local 9043
```

## Obter o IP do proxy <a name="obter-o-ip-do-proxy"></a>

Comando para obter o `ip` de um container:

```shell
docker inspect <nome_do_container> -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps --filter name=reverse -q)
```

Exemplo para obter o `ip` do rancher:

```shell
docker inspect rancher-local -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps --filter name=reverse -q)
```