
<!-- TOC -->

- [Docker](#docker)
    - [Base commands](#base-commands)
    - [Databases](#databases)
        - [Mongodb](#mongodb)
        - [Redis](#redis)
        - [PostgreSQL](#postgresql)
        - [MySQL](#mysql)
        - [RethinkDB](#rethinkdb)
        - [Couchbase](#couchbase)
        - [RabbitMQ](#rabbitmq)
        - [Kafka](#Kafka_dev)
    - [Email](#email)
        - [Email sundbox](#email-sundbox)
        - [Real email server](#real-email-server)
    - [Nginx](#nginx)
        - [Serve files](#serve-files)
        - [Letsencrypt SSL certificate](#letsencrypt-ssl-certificate)
    - [Misc](#misc)
        - [Render PDF file from HTML (file/URL)](#render-pdf-file-from-html-fileurl)
        - [Sqlite browser](#sqlite-browser)
        - [Ollama UI](#ollama-ui)
    - [Run tor proxy](#run-tor-proxy)

<!-- /TOC -->
# Docker


## Base commands

Hanging images

`docker images -f "dangling=true"`

List of all (+exited) containers

`docker ps -a`

Connect to running docker
`docker exec -it e965636ed662 sh`

## Databases

### Mongodb

```
docker run -d -p 27017:27017 --name mongodb mongo
docker run -d --name mongo -p 27017:27017 --restart=always -v $HOME/Documents/docker_volumes/mongo:/data/db -d mvertes/alpine-mongo
docker run -d --name mongo -p 27017:27017 --restart=always -v $HOME/Documents/docker_volumes/mongo:/data/db -d arm64v8/mongo
```

### Redis
```
docker run --name redis -p 6379:6379 --restart=always -d redis
```

### PostgreSQL
```
docker run --name postgres --restart=always -e POSTGRES_PASSWORD=postgres -p 127.0.0.1:5432:5432 -v $HOME/Documents/docker_volumes/postgres:/var/lib/postgresql/data -d postgres:10.4-alpine
```
run command
```
docker exec -it postgres psql -U postgres -c "create database dbname;"
```
### MySQL
```
docker run --name mysql -e MYSQL_ROOT_PASSWORD=root -v $HOME/Documents/docker_volumes/mysql:/var/lib/mysql -restart=always -p 3306:3306 -d mysql:latest
```
### RethinkDB
```
docker run --name rethinkdb -p 28015:28015 -p 8081:8080 --restart=always -v $HOME/Documents/docker_volumes/rethinkdb:/data -d rethinkdb
```
### Couchbase
```
docker run --name couchbase -p 8091-8094:8091-8094 -v /data/couchbase:/opt/couchbase/var -d couchbase:latest
```
go to cli
```
docker exec -it couchbase cbq -u couchbase -p 123123
```
### RabbitMQ
```
docker run --name rabbitmq -e RABBITMQ_DEFAULT_USER=root -e RABBITMQ_DEFAULT_PASS=root -p 15672:15672 -p 5672:5672 -d rabbitmq:3-management
```

### Kafka_dev

```
docker run -d --name kafka -p 127.0.0.1:2181:2181 -p 127.0.0.1:3030:3030 -p 127.0.0.1:8081-8083:8081-8083 -p 127.0.0.1:9581-9585:9581-9585 -p 127.0.0.1:9092:9092 -e ADV_HOST=127.0.0.1 lensesio/fast-data-dev:latest
```

## Email

### Email sundbox
```
docker run --name mailhog --restart=always -p 127.0.0.1:1025:1025 -p 127.0.0.1:8025:8025 -d mailhog/mailhog
```

### Real email server
```
docker run --name smtp --restart=always -p 1025:25 -d namshi/smtp
```

## Nginx

### Serve files
```
docker run --rm --name nginx-files -v $(pwd):/usr/share/nginx/html:ro -p 8000:80 nginx
```

### Letsencrypt SSL certificate
```
docker run -it --rm -p 443:443 -p 80:80 --name certbot -v "/etc/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" certbot/certbot certonly
```

## Misc

### Render PDF file from HTML (file/URL)
```
docker run -v /path/to/folder/with/html/document/:/root/ mrhadenough/wkhtmltopdf:latest /root/document.html /root/document.pdf
```

### Sqlite browser
```
docker run -p 127.0.0.1:2015:2015 -v /root/myapp/db/local.sqlite3:/db --name sqlite_gui -d acttaiwan/phpliteadmin
```

### Ollama UI

```
docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
```

```
docker run -u zap -p 8080:8080 -i owasp/zap2docker-stable zap-x.sh -daemon -port 8080
docker run -d -p 443:443 -p 9390:9390 -p 80:80 --name openvas mikesplain/openvas:9
docker run -p 80:80 -v /path/to/src:/src kws1/rips
docker run --name jupyter -p 8888:8888 -v $HOME/Documents/docker_volumes/jupyter:/home/jovyan/work -d jupyter/minimal-notebook
```
create database via `docker exec -i -t <container_id> su`, then`# mysq -p`, then `create database <db_name>;`


Create vpn server via docker, image: `kylemanna/openvpn` details in: [./vpn.md](./vpn.md)


### Run tor proxy
socks5 - 9050
http - 8118

```
docker run --name torproxy -p 8118:8118 -p 9050:9050 -d dperson/torproxy
```
