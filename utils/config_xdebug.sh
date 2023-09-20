#!/usr/bin/env bash

if [ -z ${XDEBUG_HOST} ]; then
  ip=$(get_xdebug_ip | tr -d '\n')
  XDEBUG_HOST=${ip}
fi

XDEBUG_CONF_2=<<EOL 
zend_extension = xdebug.so
xdebug.remote_enable = 1
xdebug.max_nesting_level = 1000
xdebug.remote_mode=req
xdebug.remote_autostart=true
xdebug.remote_log=/var/log/xdebug/xdebug.log
EOL

XDEBUG_CONF_3=<<EOL
zend_extension = xdebug.so
[xdebug]
xdebug.mode = debug,develop
xdebug.max_nesting_level = 1000
xdebug.log = /var/log/xdebug/xdebug.log
xdebug.start_with_request=yes
EOL

XDEBUG_VERSION = $(php -r "echo substr(phpversion('xdebug'),0,1);")

if [ "${XDEBUG_ENABLE}" == TRUE ]; then
  docker-php-ext-enable xdebug
fi

if [ -z ${XDEBUG_HOST} ]; then
  ip=$(netstat -rn | grep "^0.0.0.0 " | cut -d " " -f10)
  XDEBUG_HOST=${ip}
fi

if [ "${XDEBUG_VERSION}" == "3"]; then
  echo "xdebug.client_host=${XDEBUG_HOST}" >> ${XDEBUG_CONF_FILE}
  echo "xdebug.client_port=${XDEBUG_PORT}" >> ${XDEBUG_CONF_FILE}
else 
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

