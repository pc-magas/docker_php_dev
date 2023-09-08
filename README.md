# PHP Dev boilerplate
A Basic php boilerplate code that allows you to rapidly setup and develop php applications.

> NOTE:
> THE boilerplate is desighned and tested to run upon *docker engine* directly in linux hosts and not using docker desktop.

# How to use

## Step 1

Copy the `.env.dist` into `.env`

## Step 2 Populate the `.env` as comments describe.

### PHP APPLICATION VOLUME
The `PHP_APP_PATH` contains the folder in your *host* (path outside any container) that will mounted as volume in your containers.

### Network IP
The `IP_BASE` is the first 4 digits of an IPV4 IP. It can be changed in order to setup multiple dev environmnets or upon IP conflict.
For example if `IP_BASE` is `172.168.3` the used IPS are:

* Nginx `172.168.3.2`
* Mariadb `172.168.3.3`

Fpm used an intenral network whereas also nginx and mariadb also use it.

## Step 3 Run

Execute:

```
docker-compose up -d
```
