# Orange in Docker

FORK : https://github.com/syhily/docker-orange

[![](https://images.microbadger.com/badges/image/ruicky/orange.svg)](https://microbadger.com/images/ruicky/orange "Get your own image badge on microbadger.com") ![](https://img.shields.io/docker/pulls/ruicky/orange.svg) ![](https://img.shields.io/docker/stars/ruicky/orange.svg) ![](https://img.shields.io/badge/license-MIT-blue.svg)


## How to use ?

- Run a MySQL container

```bash
docker run --name orange-database -e MYSQL_ROOT_PASSWORD=your_root_pwd -e MYSQL_DATABASE=orange -p 3306:3306 mysql:5.7
```
- Run docker container

```bash
docker run -d --name orange \
    --link orange-database:orange-database \
    -p 7777:7777 \
    -p 8888:80 \
    -p 9999:9999 \
    --security-opt seccomp:unconfined \
    -e ORANGE_DATABASE={your_database_name} \
    -e ORANGE_HOST=orange-database \
    -e ORANGE_PORT={your_database_port} \
    -e ORANGE_USER={your_database_user} \
    -e ORANGE_PWD={your_database_password} \
    ruicky/orange
```


### Relative Link's

1. [Orange Dashboard](http://127.0.0.1:9999)
2. [Orange API Endpoint](http://127.0.0.1:7777)
3. [Orange Gateway Access Endpoint](http://127.0.0.1:8888)


### Operation Your Orange

```bash
docker exec -it orange orange COMMAND [OPTIONS]

The commands are:

start   Start the Orange Gateway
stop    Stop current Orange
reload  Reload the config of Orange
restart Restart Orange
version Show the version of Orange
help    Show help tips
```