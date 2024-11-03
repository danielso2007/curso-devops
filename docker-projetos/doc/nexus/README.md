## Índice

* [Start do projeto](#start-do-projeto)
* [Iniciando](#iniciando)
* [Reiniciando o k3s-local](#reiniciando-o-k3s-local)
* [Acessando o Rancher](#acessando-o-rancher)
* [Confirmação da subida do k3s-local como node do Rancher](#confirmação-da-subida-do-k3s-local-como-node-do-rancher)

[Voltar](../../README.md)

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

---
[Voltar](../../README.md)