#!/bin/sh

WEB_USER="www-data"

usermod -u ${DOCKER_UID} ${WEB_USER}
groupmod -g ${DOCKER_GID} ${WEB_USER}

echo "Setup xdebug"
cp ${XDEBUG_CONF_FILE}.orig ${XDEBUG_CONF_FILE}

echo "XDEBUG FILE IS ${XDEBUG_CONF_FILE}"

if [ -z ${XDEBUG_HOST} ]; then
  ip=$(get_xdebug_ip | tr -d '\n')
  XDEBUG_HOST=${ip}
fi

echo "xdebug.client_host=${XDEBUG_HOST}" >> ${XDEBUG_CONF_FILE}
echo "xdebug.client_port=${XDEBUG_PORT}" >> ${XDEBUG_CONF_FILE}

if [ XDEBUG_DBGP = TRUE ]; then
  echo "xdebug.remote.handler=dbgp" >>${XDEBUG_CONF_FILE}
fi

if [ ! -z "${XDEBUG_IDE_KEY}" ]; then
  echo "xdebug.idekey=\"${XDEBUG_IDE_KEY}\"" >>${XDEBUG_CONF_FILE}
fi

if [ ${XDEBUG_ENABLE} = FALSE ]; then
  sed -i "s/xdebug.mode = .*/xdebug.mode = off/" ${XDEBUG_CONF_FILE}
fi

cat ${XDEBUG_CONF_FILE}

echo "Fixing execution permissions"
find /var/www/html -iname "*.php" | xargs chmod 777

echo "Launch application"
exec "$@"