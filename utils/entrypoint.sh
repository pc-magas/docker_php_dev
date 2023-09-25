#!/bin/sh

WEB_USER="www-data"

usermod -u ${DOCKER_UID} ${WEB_USER}
groupmod -g ${DOCKER_GID} ${WEB_USER}


if [ -z ${XDEBUG_HOST} ]; then
  ip=$(get_xdebug_ip | tr -d '\n')
  XDEBUG_HOST=${ip}
fi

XDEBUG_VERSION=$(php -r "echo substr(phpversion('xdebug'),0,1);")

if [ -z ${XDEBUG_HOST} ]; then
  ip=$(netstat -rn | grep "^0.0.0.0 " | cut -d " " -f10)
  XDEBUG_HOST=${ip}
fi


if [ "${XDEBUG_VERSION}" = "3" ]; then
    echo "SETUP XDEBUG 3"
    
    cat <<EOL >${XDEBUG_CONF_FILE}
zend_extension = xdebug.so
[xdebug]
xdebug.mode = debug,develop
xdebug.max_nesting_level = 1000
xdebug.log = /var/log/xdebug/xdebug.log
xdebug.start_with_request=yes
EOL
  echo "xdebug.client_host=${XDEBUG_HOST}" >> ${XDEBUG_CONF_FILE}
  echo "xdebug.client_port=${XDEBUG_PORT}" >> ${XDEBUG_CONF_FILE}
else 
  echo "SETUP XDEBUG 2"

  cat<<EOL >${XDEBUG_CONF_FILE}
zend_extension = xdebug.so
xdebug.remote_enable = 1
xdebug.max_nesting_level = 1000
xdebug.remote_mode=req
xdebug.remote_autostart=true
xdebug.remote_log=/var/log/xdebug/xdebug.log
EOL
  echo "xdebug.remote_host=${XDEBUG_HOST}" >> ${XDEBUG_CONF_FILE}
  echo "xdebug.remote_port=${XDEBUG_PORT}" >> ${XDEBUG_CONF_FILE}
fi


# Common settings accros all version
if [ XDEBUG_DBGP = TRUE ]; then
    echo "xdebug.remote.handler=dbgp" >>${XDEBUG_CONF_FILE}
fi

if [ ! -z "${XDEBUG_IDE_KEY}" ]; then
    echo "xdebug.idekey=\"${XDEBUG_IDE_KEY}\"" >>${XDEBUG_CONF_FILE}
fi

echo "Fixing execution permissions"
find /var/www/html -iname "*.php" | xargs chmod 777

if [ -d "/var/www/.npm" ]; then
 echo "fix /var/www/.npm"
 chown -R ${WEB_USER}:${WEB_USER} /var/www/.npm
 chmod 777 /var/www/.npm
fi

if [ -d "/var/www/.composer" ]; then
 echo "fix /var/www/.composer"
 chown -R ${WEB_USER}:${WEB_USER} /var/www/.composer
 chmod 777 /var/www/.composer
fi


echo "Launch application"
exec "$@"