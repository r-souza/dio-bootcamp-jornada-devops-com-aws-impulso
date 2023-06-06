<div align="center">
  <img src="images/logo.webp" alt="Bootcamp Logo" style="width: 200px" /> 
</div>

# Desmistificando o Docker

Treinamento de introdução ao Docker

## Armazenamento de Dados

É importante ter em mente que os containers são efemeros, ou seja, toda vez que um container é parado, todos os dados armazenados no container são perdidos. Para evitar que isso ocorra, é possível persistir os dados para que sejam armazenados em um local externo ao container.

Existem 2 formas de persistir dados de containers:

<div align="center">
  <img src="images/types-of-mounts-volumes.png" alt="Bootcamp Logo" /> 
</div>

- **Volumes**: São diretórios que podem ser compartilhados entre containers, sendo completamente gerenciados pelo Docker. Para criar um volume, basta executar o comando `docker volume create` e em seguida utilizar o volume criado no container utilizando a flag `--volume`. Mais detalhes podem ser encontrados na [documentação oficial](https://docs.docker.com/storage/volumes/).
  
```
docker volume create myvolume
docker run -d --name mycontainer --volume myvolume:/opt/myvolume ubuntu
```

- **Bind Mounts**: São diretórios que podem ser compartilhados entre containers e o host, sendo possível acessar os dados diretamente por qualquer processo do host. Para utilizar um bind mount, basta utilizar a flag `--mount` e definir o tipo como `bind` e o diretório que será compartilhado, ou também é possível utilizar a flag `-v` e definir o diretório que será compartilhado. Mais detalhes podem ser encontrados na [documentação oficial](https://docs.docker.com/storage/bind-mounts/).
  
```
docker run -d --name mycontainer --mount type=bind,source=/opt/myvolume,target=/opt/myvolume ubuntu
docker run -d --name mycontainer -v /opt/myvolume:/opt/myvolume ubuntu
```

Existe ainda uma terceira forma de montar dados dentro de um container, que é utilizando `tmpfs mounts`. Essa forma pode ser interessante em cenários onde não é necessário persistir os dados, mas sim permitir o acesso rápido a eles. Por exemplo, armazenamento de dados em cache.

- **Tmpfs Mounts**: Os dados são armazenados somente na memória do host. Para utilizar um tmpfs mount, basta utilizar a flag `--mount` e definir o tipo como `tmpfs` e o diretório de destino dentro do container. Mais detalhes podem ser encontrados na [documentação oficial](https://docs.docker.com/storage/tmpfs/).
  
```
docker run -d --name mycontainer --mount type=tmpfs,target=/opt/cache ubuntu
```

## Processamento, Logs e Rede

### Processamento

Por padrão, os container são executados com acesso à todos os recursos do host. Para limitar o acesso dos containers, é possível definir limites de uso de CPU e memória utilizando as flags `--cpu-shares` e `--memory`.

```
docker run -d --name mycontainer --cpu-shares 512 --memory 512m ubuntu
```

É possível acompanhar o consumo de CPU e memória de um container utilizando o comando `docker stats`.

```
docker stats mycontainer
```

```
CONTAINER ID        NAME                CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
f7b0c9b0b0b1        mycontainer         0.00%               1.199MiB / 512MiB     0.23%               0B / 0B             0B / 0B             1
```

### Docker Top

Através do comando `docker top` é possível obter informações sobre os processos em execução dentro de um container.

```
docker top mycontainer
```

```
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
root                1234                1234                0                   12:00               ?                   00:00:00            /bin/bash
```


### Informações e Logs

Existem alguns comandos que podem ser utilizados para obter informações sobre os containers em execução. 

#### Docker Inspect

Docker Inspect é um comando que pode ser utilizado para obter informações sobre containers, imagens, volumes, redes e plugins.

Por exemplo, para saber onde um container está conectado, basta executar o comando `docker inspect` e filtrar o resultado pelo campo `NetworkSettings.Networks`.

```
docker inspect mycontainer
```

```json
[
    {
        "Id": "f7b0c9b0b0b1
        "Name": "mycontainer",
        "State": {
            "Status": "running",
            "Running": true,
            ...
            ... 
        },
        "NetworkSettings": {
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "f7b0c9b0b0b1",
                    "EndpointID": "f7b0c9b0b0b1",
                    "Gateway": "
                    ...
```

Um outro exemplo pode ser obtido utilizando o comando `docker inspect` e filtrando o resultado pelo campo `Mounts`.

```
docker inspect mycontainer
```

```json
[
    {
        "Id": "f7b0c9b0b0b1
        "Name": "mycontainer",
        "State": {
            "Status": "running",
            "Running": true,
            ...
            ... 
        },
        "Mounts": [
            {
                "Type": "volume",
                "Name": "myvolume",
                "Source": "/var/lib/docker/volumes/myvolume/_data",
                "Destination": "/opt/myvolume",
                "Driver": "local",
                "Mode": "",
                "RW": true,
                "Propagation": ""
            }
        ]
    }
]
```

Também é possível inspecionar os volumes utilizando o comando `docker volume inspect`.

```
docker volume inspect myvolume
```

```json
[
    {
        "CreatedAt": "2020-05-01T12:00:00Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/myvolume/_data",
        "Name": "myvolume",
        "Options": {},
        "Scope": "local"
    }
]
```

#### Docker Logs

Para obter os logs de um container, basta executar o comando `docker logs`.

```
docker logs mycontainer
```

```
2020-05-01 12:00:00 INFO: Starting application
2020-05-01 12:00:00 INFO: Application started
```

#### Docker Info

Através do comando `docker info` é possível obter informações sobre o host e os containers em execução.

```
docker info
```

```
Containers: 1
 Running: 1
 Paused: 0
 Stopped: 0
Images: 1
...
```

### Rede

Por padrão, os containers são executados em uma rede chamada **bridge**, que tem acesso ao Host. Para que os containers possam se comunicar entre si, é necessário que eles estejam em uma mesma rede. Para isso, é necessário criar uma rede e adicionar os containers nessa rede.

Para listar as redes existentes, basta executar o comando `docker network ls`.

```
docker network ls
````

```
NETWORK ID          NAME                DRIVER              SCOPE
f7b0c9b0b0b1        bridge              bridge              local
f7b0c9b0b0b1        host                host                local
f7b0c9b0b0b1        none                null                local
```

Para criar uma rede, basta executar o comando `docker network create`.

```
docker network create mynetwork
```

Com a rede criada, podemos adicionar um container a essa rede utilizando a flag `--network`.

```
docker run -d --name mycontainer --network mynetwork ubuntu
docker run -d --name mycontainer2 --network mynetwork ubuntu
```

Uma vez que os containers estão na mesma rede, é possível acessá-los utilizando o nome do container.

```
docker exec -it mycontainer ping mycontainer2
```

## Definição e criação de um Dockerfile

Para criar uma imagem personalizada do Docker, basta criar um Dockerfile com todas as definições necessárias. 

Veja abaixo um exemplo de docker file que copia um arquivo `app.py` e o executa assim que um container for lançado utilizando a imagem gerada.

```dockerfile
FROM ubuntu

RUN apt update && apt install -y python3 && apt clean

COPY app.py /opt/app.py

CMD python3 /opt/app.py
```

Após definido o Dockerfile, basta executar o comando `docker build` para gerar a imagem. 
```
docker build -t ubuntu-python:1.0 .
```

### Exemplo de Dockerfile para criação de imagem personalizada do Apache
  
```dockerfile
FROM debian

RUN apt-get update && apt-get install apache2 -y && apt-get clean

ADD site.tar.gz /var/www/html

LABEL description = "Apache webserver 1.0"

VOLUME /var/www/html

EXPOSE 80

ENTRYPOINT ["/usr/sbin/apachectl"]

CMD ["-D", "FOREGROUND"]
```

### Exemplo de Dockerfile para criação de imagem personalizada do Python 
  
```dockerfile
FROM python:3

WORKDIR /usr/src/app

COPY app.py /usr/src/app

CMD [ "python", "./app.py" ]
```

### Gerando uma imagem MULTISTAGE

É possível definir arquivos Dockerfiles utilizando a técnica de multistage build, que permite que uma imagem seja gerada copiando arquivos de uma estágio de build anterior. Uma das vantagens dessa técnica é que a imagem final não precisa conter todas as dependências necessárias para o build, apenas as necessárias para a execução do software, fazendo com que a imagem final seja menor.

Veja abaixo um exemplo de Dockerfile que utiliza a técnica de multistage build para gerar uma imagem final com apenas **11MB**, enquanto a imagem utilizada na fase de build possui **992MB**.

```dockerfile
FROM golang as golang-builder

COPY app.go /go/src/app/

ENV GO111MODULE=auto

WORKDIR /go/src/app

RUN go build -o app.go .

FROM alpine

WORKDIR /appexec
COPY --from=golang-builder /go/src/app/ /appexec
RUN chmod -R 755 /appexec
ENTRYPOINT ./app.go
```

Para gerar a imagem , basta realizar o build normalmente.

```
docker build -t golang-app:1.0 .
```

### Realizando o upload de imagens para o Docker Hub

Para realizar o upload de uma imagem para o Docker Hub, basta realizar o login no Docker Hub, fazer o build da imagem com uma tag seguindo o padrão "username/imagename" e em seguida realizar o push da imagem.

```
docker login
docker build -t myuser/myimage:1.0 .
docker push myuser/myimage:1.0
```

### Criando um Registry Privado

Para criar um registry privado, basta executar o comando abaixo, que irá criar um container com o registry privado.

```
docker run -d -p 5000:5000 --restart=always --name registry registry:2
````

Após a criação do registry privado, basta realizar o login no registry privado, fazer o build da imagem com uma tag seguindo o padrão "registryserver:5000/imagename" e em seguida realizar o push da imagem.

```
docker login registryserver:5000
docker build -t registryserver:5000/myimage:1.0 .
docker push registryserver:5000/myimage:1.0
```

Caso o registry privado não rode utilizando um certificado SSL, é necessário adicionar a flag `--insecure-registry` no arquivo `/etc/docker/daemon.json` para que o docker consiga realizar o push das imagens.

```json
{
  "insecure-registries" : ["registryserver:5000"]
}
```

Se necessário verificar as imagens disponíveis no registry privado, basta acessar a url http://registryserver:5000/v2/_catalog.

````
curl http://registryserver:5000/v2/_catalog
````

### Docker Compose

Docker compose é uma ferramenta desenvolvida para facilitar a criação e execução de containers Docker. Com o docker compose, é possível definir um arquivo de configuração YAML com todas as definições necessárias para a criação de containers, como por exemplo, nome do container, imagem, portas, volumes, etc.

#### Instalação do Docker Compose no Ubuntu

Para instalar o docker compose no Ubuntu, basta executar o comando abaixo.

```
sudo apt install docker-compose
```

Com o docker compose instalado, basta criar um arquivo `docker-compose.yml` com as definições necessárias para a criação dos containers.

Abaixo um exemplo de arquivo docker-compose.yml para criação de um container com o MySQL e outro com o Adminer, ambos conectados em uma mesma rede.

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: database_name
      MYSQL_USER: database_user
      MYSQL_PASSWORD: database_password
    ports:
      - "3306:3306"
    volumes:
      - ./mysql/data:/var/lib/mysql
    restart: always
    networks:
      - app-network 

  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
```

Vários exemplos interessantes de arquivos docker-compose.yml podem ser encontrados no repositório [awesome-compose](https://github.com/docker/awesome-compose/) do Docker.

### Lab - Criando um container de uma aplicação web com Docker Compose

Abaixo o conteúdo do arquivo docker-compose.yml utilizado para criação de um container com uma aplicação web estática utilizando o template [Venus](https://cruip.com/demos/venus/).

```yaml
version: '3.8'

services:
  app:
    image: nginx:alpine
    volumes:
      - ./app:/usr/share/nginx/html # Template from https://cruip.com/demos/venus/
    ports:
      - 8000:80
```

Demais arquivos desse laboratório estão disponíveis em [lab](lab/) 

## Criando um Cluster com o Docker Swarm

Um Cluster considte em computadores ligados que trabalham em conjunto, de modo que, em muitos aspectos, podem ser considerados como um único sistema. Computadores em cluster executam a mesma tarefa, controlado e programado por software. Cada computador presente em um cluster é conhecido como nó.

### O que é o Docker Swarm?

O Swarm é um recurso do Docker que fornece funcionalidades de orquestração de container, incluindo clustering nativo de hosts do Docker e agendamento de cargas de trabalaho de containers. Um grupo de hosts do Docker formam um cluster "Swarm"

### Como funciona o Docker Swarm?

O Docker Swarm é composto por um ou mais nós, que podem ser gerenciados por um nó manager. O nó manager é responsável por gerenciar o cluster, enquanto o nó worker é responsável por executar as tarefas.

### Como criar um Cluster com o Docker Swarm

Para criar um cluster com o Docker Swarm, basta executar o comando abaixo em um dos nós que irá compor o cluster.

```
docker swarm init
```

Após a execução do comando, será exibido um token que será utilizado para adicionar novos nós ao cluster. Veja abaixo um exemplo:

```
Swarm initialized: current node (dxn1zf6l61qsb1josjja83ngz) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
    192.168.99.100:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

Mais detalhes podem ser encontrados na [documentação oficial do Docker:](https://docs.docker.com/engine/reference/commandline/swarm_init/)

#### Adicionando novos nós ao Cluster

Para adicionar um novo nó como worker, basta executar o comando abaixo no nó que irá compor o cluster.

```
docker swarm join \
    --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
```

#### Listando os nós do Cluster

Para listar os nós do cluster, basta executar o comando abaixo.

```
docker node ls
```

Você verá uma saída semelhante a esta:

```
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION

dxn1zf6l61qsb1josjja83ngz *   docker-desktop      Ready               Active              Leader              19.03.8
```

### Criando um serviço com o Docker Swarm

Para criar um serviço com o Docker Swarm, basta executar o comando `docker service create`, como pode ser visto abaixo:

```
docker service create --name webserver --replicas 15 -p 80:80 nginx
```

O comando acima irá criar um serviço chamado webserver com 15 réplicas do container nginx, sendo que cada réplica será executada em um nó diferente do cluster.

Para listar os serviços do cluster, basta executar o comando abaixo.

```
docker service ls
```

Para forçar que um nó deixe de receber containers, basta executar o comando abaixo.

```
docker node update --availability drain <node>
```

Para reativar um nó para receber containers, basta executar o comando abaixo.

```
docker node update --availability active <node>
```

### Consistência de dados em um Cluster

Quando um container é criado em um nó, o Docker Swarm cria um volume para armazenar os dados do container. Esse volume é criado em um nó específico e não é compartilhado com os demais nós do cluster. Isso significa que, se um container for criado em um nó e posteriormente for movido para outro nó, os dados do container não serão movidos junto com o container.

Podemos resolver a questões descrita acima utilizando o `nfs-server` para compartilhar o caminho do volume entre os nós do cluster.

####  Instalando o nfs-server
```
apt install nfs-server
```

#### Configurando o nfs-server

Para configurar o nfs-server, basta editar o arquivo `/etc/exports` e adicionar o caminho do volume que será compartilhado entre os nós do cluster. Veja abaixo um exemplo:

```
/var/lib/docker/volumes/app/_data *(rw,sync,subtree_check)
```

Salve o arquivo e execute o comando abaixo para aplicar as alterações.

```
exportfs -ar
```

Não se esqueça de abrir a porta 2049 no firewall do servidor.

#### Montando o volume compartilhado

Para montar o volume compartilhado, primeiro é necessário instalar o pacote `nfs-common` no nó que irá receber o volume compartilhado.

```
apt install nfs-common
```

Após a instalação do pacote, basta executar o comando abaixo para montar o volume compartilhado.

```
mount -t nfs <ip-do-servidor>:/var/lib/docker/volumes/app/_data /var/lib/docker/volumes/app/_data
```