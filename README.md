# PHP Dev boilerplate
A Basic php boilerplate code that allows you to rapidly setup and develop php applications.

> NOTE:
> 
> THE boilerplate is desighned and tested to run upon *docker engine* directly in *GNU/linux* hosts and not using docker desktop.

# How to use

## Step 0 (Optional)

Create a branch for a new project.

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

#### PHP APPLICATION NAME (also used as project name)
The `APP_NAME` environmental variable is also used for various usages:
* As a container name prefix
* As a project name
* As a php image name prefix

Is is important to set it up in order to have the containers unaffected from other `docker-compose.yml` files having the same service names.

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

### For PHP
The volume `php_app` is mapped upon the folder via bind mount  at the path defined in `${PHP_APP_PATH}`.
Also there is a volume mounted upon `logs/xdebug` where the xdebug log ist stored upon.

### For www-data Home user
Upon PHP container an extra folder `/home/www-data` is created this is used for composer cache, npm cache and ssh settings.
For ssh settings and keys. Moung you host path at `~/.ssh_config` folder. Its contents are copied upon `~/.ssh` via entrypoint script.

## Mariadb

### For Database Data 
The folder `./volumes/db` is mapped into `/var/lib/mysql` via bind mount therefore upon `docker-compose down -v` will NOT be deleted.

### For settiung up a test database (usefull for unit and iontegration tests)
Also a script located upon `./provision/db/maria/setup_test_db.sh` is used. That script is creates a seperate db for the user `$MYSQL_USRT` named as the one defined upon `$MYSQL_DATABASE` but with `test_` prefixed into it. This is used for dbs tat are used for testing.

# Environments

Beyond `.env` each service has its own env file as well. These are located upon `env` folder:

* `env/php.env` Configures the environment for `php_app` service. This is the service that runs php_fpm.
* `env/mysql_maria.env` Configures the environment for `mariadb` service. This is the service that runs mariadb

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
--- | --- | ---
XDEBUG_IDE_KEY | IDE key where used to define the IDE
XDEBUG_PORT | Port where xdebug will be connected in to
XDEBUG_ENABLE | Whether xdebug will be enabled or not | `TRUE` or `FALSE`
XDEBUG_DBGP | Whether DBGP protocol will be used | `TRUE` or `FALSE`
XDEBUG_ENABLE | Whether Xdebug is enabled or not | `TRUE` or `FALSE`
XDEBUG_HOST | Host where Xdebug listens to. If no value provided then it is auto-detected |



The IP where IDE listen to is automatically detected. In order to test the connectivity upon php container use the following command once you got shell access into the php running container:

```
test_xdebug
```

In order to get access upon the php running container run:

```
docker exec -ti -u www-data php_app /bin/bash
```

> NOTE: 
>
> In case that an already existing container has the name `php_app` change the value `container_name` at `php_app` service.

# PHP And composer version

At docker-compose.yml at the service `php_app` you can define composer and php version app via the following args:

* `PHP_VERSION` for the php version
* `COMPOSER_VERSION` for the composer version. This is the tags defined at composer docker [image](https://hub.docker.com/_/composer/tags) 

If each argument is changed run the containers as:

```
docker-compose up -d --build
```

# SSL Certificates

There is a script named `./bin/certgen.sh` that is used to generate the nessesary certificates. is creates the following certificates:

* CA root ones at ./ssl/ca folder:
  * ca.crt << Certificate
  * ca.key << Certificate key

* Ones used by nginx at ./ssl/certs folder:
  * www.crt << Certificate
  * www.key << Certificate key

Import the CA ones to your browser.

The configuration for the domains that certs are used are in the file `ssl/conf/v3.sign` read comments in it in order how to configure it.
