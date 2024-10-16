## Jenkins: Seu Guia Completo para Automação de CI/CD

### O que é Jenkins?

O Jenkins é uma ferramenta de automação open-source amplamente utilizada para implementar práticas de Integração Contínua (CI) e Entrega Contínua (CD). Ele permite automatizar tarefas repetitivas no desenvolvimento de software, como compilação, testes, implantação e muito mais.

**Em resumo, o Jenkins atua como um mestre de cerimônias, orchestrando todas as etapas do seu pipeline de desenvolvimento.**

* **Automação de builds:** Compila o código-fonte automaticamente a cada nova alteração.
* **Execução de testes:** Realiza testes unitários, de integração e outros tipos de testes para garantir a qualidade do software.
* **Implantação automatizada:** Implanta o software em diferentes ambientes (desenvolvimento, testes, produção).
* **Integração com outras ferramentas:** Se integra com uma variedade de ferramentas e tecnologias, como Git, Docker, Kubernetes, etc.
* **Extensibilidade:** Permite a criação de plugins para personalizar e expandir suas funcionalidades.

* **Integração Contínua (CI):** Automatiza a integração de código de diferentes desenvolvedores em um repositório central, garantindo que o software sempre esteja em um estado funcional.
* **Entrega Contínua (CD):** Automatiza o processo de entrega de software para os usuários finais, permitindo lançamentos mais frequentes e com menor risco.
* **DevOps:** Facilita a colaboração entre equipes de desenvolvimento e operações, acelerando o ciclo de vida do software.

* **Open-source:** Gratuito e com uma grande comunidade de usuários.
* **Flexível:** Pode ser configurado para atender às necessidades de qualquer projeto.
* **Extensível:** Possui uma vasta gama de plugins para adicionar funcionalidades.
* **Fácil de usar:** Interface web intuitiva e fácil de configurar.
* **Escalabilidade:** Pode ser facilmente escalado para lidar com projetos grandes e complexos.

## Documentação

* **Documentação oficial do Jenkins:** https://www.jenkins.io/doc/
* **GoCache: O que é Jenkins? Para iniciantes:** https://gocache.com.br/dicas/o-que-e-jenkins-para-iniciantes/
* **Coodesh: O que é Jenkins?** https://coodesh.com/blog/dicionario/o-que-e-jenkins/

## Resumo

O Jenkins é uma ferramenta essencial para qualquer equipe que busca automatizar seus processos de desenvolvimento e entrega de software. Ao adotar o Jenkins, você pode aumentar a qualidade do seu software, reduzir o tempo de lançamento no mercado e melhorar a colaboração entre os membros da equipe.

## Após instalação

O Jenkins é instalado no virtualbox usando o `vagrant`. Após iniciar o `vagrant up` no terminal, acessar a máquina via ssh `vagrant ssh` e obter a senha do administrador:

```shell
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
Essa senha é mostrada no final da subida o `vagrant up`.

## Acessando o jenkins

Acesse: [http://localhost:8080](http://localhost:8080/login?from=%2F)

## <a name="_s0f6we7cz40"></a>**CI/CD: Uma Visão Geral e Exemplos no Jenkins**
### <a name="_2c9lsgv8ystz"></a>**O que é CI/CD?**
**CI/CD** é um acrônimo para **Integração Contínua** (Continuous Integration) e **Entrega Contínua** (Continuous Delivery). É uma prática de desenvolvimento de software que visa automatizar o processo de construção, teste e implantação de software. O objetivo principal é reduzir o tempo entre a escrita do código e sua disponibilização para os usuários finais, aumentando a qualidade e a frequência das entregas.

- **Integração Contínua (CI):** Envolve a integração frequente das mudanças de código em um repositório central. Cada integração é verificada por meio de um build automático que inclui testes para garantir que as novas mudanças não introduzam erros.
- **Entrega Contínua (CD):** É a prática de tornar todas as alterações de código candidatas a serem implantadas em um ambiente de produção. Isso significa que o software é sempre testável e pronto para ser lançado.
### <a name="_ahgyqtf1ckle"></a>**Exemplos de CI/CD no Jenkins**
O Jenkins é uma das ferramentas mais populares para implementar práticas de CI/CD. Ele oferece uma ampla gama de funcionalidades para automatizar o pipeline de desenvolvimento.

**Exemplos de como o Jenkins pode ser utilizado:**

- **Criando um pipeline:** O Jenkins permite criar pipelines visuais ou baseados em scripts (como Groovy) para definir as etapas do seu processo de CI/CD. Um pipeline típico pode incluir:
  - **Checkout:** Baixar o código-fonte do repositório.
  - **Build:** Compilar o código em um artefato executável.
  - **Testes:** Executar testes unitários, de integração e outros.
  - **Deploy:** Implantar o artefato em diferentes ambientes (desenvolvimento, testes, produção).
- **Automatizando testes:** O Jenkins pode ser configurado para executar diferentes tipos de testes, como testes unitários, de integração, de aceitação e de desempenho. Isso garante que as alterações de código não introduzam regressões.
- **Gerenciando múltiplos projetos:** O Jenkins pode gerenciar pipelines para diversos projetos, permitindo uma visão consolidada do status de todos os seus projetos.
- **Integrando com outras ferramentas:** O Jenkins se integra com uma variedade de ferramentas, como Git, Docker, Kubernetes, e ferramentas de testes como JUnit e Selenium.
- **Notificações:** O Jenkins pode enviar notificações por e-mail, Slack ou outras plataformas para informar sobre o status das builds, testes e deployments.

**Exemplo de um pipeline básico no Jenkins:**
```Groovy
pipeline {
      agent any
      stages {
          stage('Checkout') {
              steps {
                  git branch: 'main', url: 'https://github.com/your-repo.git'
              }
          }
          stage('Build') {
              steps {
                  sh 'mvn clean package'
              }
          }
          stage('Test')  
{
              steps {
                  sh 'mvn test'
              }
          }
          stage('Deploy') {
              steps {
                  sh 'docker build -t my-image .'
                  sh 'docker push my-image'  
                  // ...
              }
          }
    }
}
```

**Este pipeline:**

1. Faz o checkout do código-fonte do repositório Git.
1. Compila o projeto usando Maven.
1. Executa os testes.
1. Cria uma imagem Docker e a envia para um registro.
### <a name="_8vp89fmxtxk"></a>**Benefícios do CI/CD com Jenkins**
- **Aumento da qualidade do software:** Detecção precoce de erros e bugs.
- **Redução do tempo de lançamento:** Entrega mais rápida de novas funcionalidades.
- **Melhoria da colaboração:** Facilita a colaboração entre desenvolvedores e equipes.
- **Aumento da confiabilidade:** Processos automatizados e repetíveis.
- **Maior frequência de releases:** Possibilidade de fazer pequenas entregas com mais frequência.

**Em resumo,** o Jenkins é uma ferramenta poderosa para implementar práticas de CI/CD, permitindo que as equipes de desenvolvimento entreguem software de alta qualidade com mais rapidez e confiabilidade.

# Exemplo pipeline

Foi criado um repositório privado no github `redis-app`. Depois criado um pipeline com as configurações abaixo:

- Nova tarefa
- Nome `redis-app` do tipo pipeline
- Em `Pipeline`, definir como `Pipeline script from SCM`
- SCM como git
- Adicionar o `Repositories URL`
- Adicionar as credenciais: `jenkins-casa` -> No github, criar em `Personal access tokens`
- Criar um arquivo `Jenkinsfile`

## Testando a aplicação

Entrar no vagrant `vagrant ssh` e executar:

```shell
curl http://localhost:8081/contador
```

## Associado ao projeto Sonar

Tem o estudo anterior que conecta o sonar ao jenkins. Para testar a comunicação interna, usar: `telnet 192.168.56.6 9000`

## Plugin do Jenkins

Doc: [jenkins-integration/global-setup](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/ci-integration/jenkins-integration/global-setup/)

Em `Painel de controle > Gerenciar Jenkins > Plugins`, baixar o `SonarQube Scanner for Jenkins`.

Acesse as configurações do Jenkins: [localhost:8080/manage/configure](http://localhost:8080/manage/configure)

- `Environment variables` = check true
- Add SonarQube
- Name: sonar-sever
- Server URL: http:192.168.56.6:9000
- Add Server authentication token --> Criar lá no sonar
- Kind: `Secret text`
- Secret: adicionar o token criado no Sonar
- ID: secret-sonar

### Configurar o tools

Ir em `Painel de controle > Gerenciar Jenkins > Tools`. Acessar: SonarQube Scanner instalações.

- Name: sonar-scanner
- Não instalar automaticamente
- SONAR_RUNNER_HOME: `/opt/sonar-scanner`
