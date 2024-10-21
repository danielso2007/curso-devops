# Nexus

O **Apache Nexus** é uma ferramenta usada para gerenciar repositórios de artefatos de software, comumente utilizada para armazenamento de dependências de build (como bibliotecas Java) e pacotes de software (como releases, snapshots e plugins). Ele facilita o controle de versões, a governança de dependências e o gerenciamento de repositórios, seja em um ambiente público ou privado.

## Principais Funcionalidades:

1. Repositórios de Proxy: Nexus permite que você configure repositórios de proxy que se conectam a repositórios remotos, como o Maven Central. Assim, é possível fazer o cache local de artefatos, reduzindo o tempo de download e aumentando a resiliência do build.
2. Repositórios de Hospedagem (Hosted Repositories): Repositórios locais onde você pode armazenar seus próprios pacotes, sejam eles artefatos de produção ou snapshots.
3. Grupos de Repositórios: Nexus suporta o agrupamento de vários repositórios (locais e proxy) para facilitar a configuração de um ponto único de acesso para os builds.
4. Suporte a Múltiplos Formatos: Além de Java/Maven (formato jar), o Nexus suporta vários outros tipos de pacotes, como npm, docker, nuget, rubygems, yum etc.
5. Gerenciamento de Usuários e Permissões: Ele permite a criação de roles e a configuração granular de permissões de acesso aos repositórios.
6. Governança de Dependências: Permite configurar regras para controlar quais artefatos podem ou não ser usados nos builds, garantindo a conformidade com as políticas da organização.

## Fluxo de Trabalho Comum:

- Build Tools (ex: Maven, Gradle) consultam os repositórios no Nexus para baixar dependências ou fazer deploy de artefatos.
- O Nexus pode baixar dependências de repositórios remotos ou armazenar artefatos de builds em seus repositórios internos.

## Documentação Oficial

Você pode encontrar a documentação completa em [Nexus Repository Manager Documentation](https://help.sonatype.com/en/sonatype-nexus-repository.html), que oferece detalhes sobre como configurar repositórios, gerenciar permissões e otimizar o uso de caching e proxy.

# Explicação:

- `services.nexus.image`: Utiliza a última versão da imagem `sonatype/nexus3`, que é a versão mais atual do Nexus 3.
- `container_name`: Nomeia o container como "nexus" para fácil identificação.
- `ports`: Mapeia a porta 8081 do container para a porta 8081 do host. Essa é a porta padrão que o Nexus utiliza.
- `volumes`: Monta um volume para persistência dos dados em `/nexus-data`, garantindo que os dados sejam preservados entre reinicializações.
- `environment`: A variável `NEXUS_SECURITY_RANDOMPASSWORD=false` desabilita a criação de uma senha aleatória para o admin na primeira inicialização, o que facilita o acesso inicial. A senha será `admin` e o usuário será `admin123` (conforme configuração padrão do Nexus).
- `restart`: Configura o container para reiniciar automaticamente caso ocorra falha ou após reiniciar o Docker.

# Iniciando a aplicação

Antes de iniciar, verificar o item SSL abaixo. O Nexus subirá em https.

Usar `./start.sh` e acessar [localhost:8094](http://localhost:8094/).

Quando logar pela primeira vez, usar login: `admin` e senha: `admin123`.

### SSL

Antes de tudo, é preciso criar o certificado para colocarmos o docker registry em HTTPS.

Executar dentro da pastas `ssl`:
```shell
keytool -genkeypair -alias nexus -keyalg RSA -keysize 2048 -keystore nexus.jks -validity 365
```

No exemplo acima, coloquei a senha: `123456`. Esse senha foi colocada no `jetty/jetty-https.xml`.

## Criando usuário para integração com o jenkins

Para a integração com o jenkins, criar um usuário login `jenkins` e senha `jenkins123`. Lembrando de é apenas estudo, por isso essa simplicidade de login e senha. É preciso criar no Jenkins das credenciais, com ID `jenkins-nexus`, assim o pipeline da aplciação pega as informações para subir a imagens para o nexus.

## Criar um docker repo

Para nosso estudo, criar um repositório para as imagens docker (registry docker).

- Repositories
  - docker (hosted)
    - nome: `docker-repo`
    - HTTPS: `8123` | Exposto lá no docker compose

## Teste manual

Subindo de forma manual.

Fazer login local do docker par ao nexus do estudo: `docker login localhost:8123` ou `docker login -u jenkins -p jenkins123 localhost:8123`.
Usar o login e senha criados acima.

Agora, precisamos taguear a imagem docker para o novo nexus: `docker tag node/redis-app:latest localhost:8123/node/redis-app`. Para esse exemplo, usamos o projeto `jenkins-lab/redis-app`. Crie uma imagem a partir desse projeto, executando a shell `criar_imagem.sh`. Ele criará a imagem com o nome: `node/redis-app:latest`.

Subindo para o repositório local: `docker push localhost:8123/node/redis-app`. Todo o processo pode ser chamado por essa shell: `./tag_and_push.sh`.

# Integrando o jenkins com o nexus

Criar uma variável global no jenkins: `NEXUS_URL=localhost:8123`.