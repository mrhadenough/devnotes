### Docker

List of images

`docker images`

Run instance

`hello-world`

List of containers

`docker ps -a`

Connect to running docker
`docker exec -i -t e965636ed662 sh`

Examples:

```
docker run -i -t hello-world busybox sh

docker run -u zap -p 8080:8080 -i owasp/zap2docker-stable zap-x.sh -daemon -port 8080

docker run -p 80:80 -v /path/to/src:/src kws1/rips

docker run -d -p 27017:27017 --name mongodb mongo

docker run --name jupyter -p 8888:8888 -d jupyter/minimal-notebook

docker run --name mysql -e MYSQL_ROOT_PASSWORD=root -v /Users/kostya/Documents/docker_volumes/mysql:/var/lib/mysql -restart=always -p 3306:3306 -d mysql:latest

docker run --name redis -p 6379:6379 --restart=always -d redis

docker run -d -p 443:443 -p 9390:9390 -p 80:80 --name openvas mikesplain/openvas:9

docker run --name postgres --restart=always -e POSTGRES_PASSWORD=postgres -p 127.0.0.1:5432:5432 -v ~/Documents/docker_volumes/postgres:/var/lib/postgresql/data -d postgres:9.5

docker run --name postgres --restart=always -e POSTGRES_PASSWORD=postgres -p 127.0.0.1:5432:5432 -v ~/Documents/docker_volumes/postgres:/var/lib/postgresql/data -d kiasaki/alpine-postgres:9.5

docker run --name mailhog --restart=always -p 127.0.0.1:1025:1025 -p 127.0.0.1:8025:8025 -d mailhog/mailhog
```

create database via `docker exec -i -t <container_id> su`, then`# mysq -p`, then `create database <db_name>;`
