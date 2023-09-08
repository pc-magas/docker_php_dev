# PHP Dev boilerplate
A Basic php boilerplate code that allows you to rapidly setup and develop php applications.

> NOTE:
> THE boilerplate is desighned and tested to run upon *docker engine* directly in *GNU/linux* hosts and not using docker desktop.

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
More info on networking section

## Step 3 Run

Execute:

```
docker-compose up -d
```

# Shut it down

## Terminate running containers

Run:

```
docker-compose down -v
```

# VOLUMES

## PHP & Nginx

The volume `php_app` is mapped upon the folder via bind mount  at the path defined in `${PHP_APP_PATH}`.

Also there is a volume mounted upon `logs/xdebug` where the xdebug log ist stored upon.

## Mariadb

The folder `./volumes/db` is mapped into `/var/lib/mysql` via bind mount therefore upon `docker-compose down -v` will NOT be deleted.

# Networks

There are 2 networks:

* `private` Intended to run as internal network for containers that need no public access.
* `public` Intended to run as internal network for containers that need no public access.

The follwing IP are allocated by default:

IP | SERVICE
--- | ---
nginx | X.X.X.2
mariadb | X.X.X.3

Where **X.X.X.X** is defined upon `IP_BASE` environmental variable.

# Xdebug

The xdebug settings are set via the following variables at file `env/php.env`:

Variable | Description | Available values
--- | --- |

XDEBUG_IDE_KEY | IDE key where used to define the IDE
XDEBUG_PORT | Port where xdebug will be connected in to
XDEBUG_ENABLE | Whether xdebug will be enabled or not | `TRUE` or `FALSE`
XDEBUG_DBGP | Whether DBGP protocol will be used | `TRUE` or `FALSE`
XDEBUG_ENABLE | Whether Xdebug is enabled or not | `TRUE` or `FALSE`



The IP where IDE listen to is automatically detected. In order tot est the connectivity upon php container use the following command once you got shell access into the php running container:

```
test_xdebug
```

In order to get access upon the php running container run:

```
docker exec -ti -u www-data php_app /bin/bash
```

> NOTE: In case that an already existing container has the name `php_app` change the value `container_name` at `php_app` service.