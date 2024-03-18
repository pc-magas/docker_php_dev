#!/bin/bash

WEB_USER="www-data"

usermod -u ${DOCKER_UID} ${WEB_USER}
groupmod -g ${DOCKER_GID} ${WEB_USER}

chown ${WEB_USER}:${WEB_USER} ${WWW_HOME}

if [ -z ${XDEBUG_HOST} ]; then
  ip=$(get_xdebug_ip | tr -d '\n')
  XDEBUG_HOST=${ip}
fi

docker-php-ext-enable xdebug

XDEBUG_VERSION=$(php -r "echo substr(phpversion('xdebug'),0,1);")
echo "Detected xdebug version ${XDEBUG_VERSION}"

cat ${XDEBUG_CONF_FILE}

if [ "${XDEBUG_VERSION}" = "3" ]; then
  echo "SETUP XDEBUG 3"

  echo "[xdebug]" >> ${XDEBUG_CONF_FILE} 
  echo "xdebug.max_nesting_level = 1000" >> ${XDEBUG_CONF_FILE} 
  echo "xdebug.log = /var/log/xdebug/xdebug.log" >> ${XDEBUG_CONF_FILE} 
  echo "xdebug.discover_client_host=false" >> ${XDEBUG_CONF_FILE}
  echo "xdebug.start_with_request = trigger" >> ${XDEBUG_CONF_FILE}

  echo "xdebug.client_host=${XDEBUG_HOST}" >> ${XDEBUG_CONF_FILE}
  echo "xdebug.client_port=${XDEBUG_PORT}" >> ${XDEBUG_CONF_FILE}

  XDEBUG_ENABLE=$(echo "${XDEBUG_ENABLE}" | tr '[:upper:]' '[:lower:]')
  echo $XDEBUG_ENABLE
  if [ "${XDEBUG_ENABLE}" == "true" ]; then
    echo "HERE"
   echo "xdebug.mode = debug,develop" >> ${XDEBUG_CONF_FILE}
  else
   echo "xdebug.mode = off" >> ${XDEBUG_CONF_FILE}
  fi

else 
  echo "SETUP XDEBUG 2"

  
  echo "xdebug.max_nesting_level = 1000" >>  ${XDEBUG_CONF_FILE}
  echo "xdebug.remote_mode=req" >>  ${XDEBUG_CONF_FILE}
  echo "xdebug.remote_autostart=0" >> ${XDEBUG_CONF_FILE}
  echo "xdebug.remote_log=/var/log/xdebug/xdebug.log" >> ${XDEBUG_CONF_FILE}

  echo "xdebug.remote_host=${XDEBUG_HOST}" >> ${XDEBUG_CONF_FILE}
  echo "xdebug.remote_port=${XDEBUG_PORT}" >> ${XDEBUG_CONF_FILE}

  if [ "${XDEBUG_ENABLE}" == "true" ]; then
   echo "xdebug.remote_enable = 1" >>  ${XDEBUG_CONF_FILE}
  else
   echo "xdebug.remote_enable = 0" >>  ${XDEBUG_CONF_FILE}
  fi
fi

if [ ! -z "${XDEBUG_IDE_KEY}" ]; then
  echo "xdebug.idekey=\"${XDEBUG_IDE_KEY}\"" >> ${XDEBUG_CONF_FILE}

  if [ "${XDEBUG_IDE_KEY}" == "PHPSTORM" ]; then
    XDEBUG_DBGP=true
  fi

fi

touch /var/log/xdebug/xdebug.log
chown root:root /var/log/xdebug/xdebug.log
chmod 666 /var/log/xdebug/xdebug.log

# Common settings accros all version
if [ XDEBUG_DBGP = TRUE ]; then
    echo "xdebug.remote.handler=dbgp" >>${XDEBUG_CONF_FILE}
fi

echo "Fixing execution permissions"
find /var/www/html -iname "*.php" | xargs chmod 777

if [ -d "/var/www/.npm" ]; then
 echo "fix /var/www/.npm"
 chown -R ${WEB_USER}:${WEB_USER} /var/www/.npm
 chmod 777 /var/www/.npm
fi

if [ -d "${WWW_HOME}/.composer" ]; then
 echo "fix /var/www/.composer"
 chown -R ${WEB_USER}:${WEB_USER} ${WWW_HOME}/.composer
 chmod 777 ${WWW_HOME}/.composer
fi

echo "GENERATING .bashrc"
echo "" > ${WWW_HOME}/.bashrc;
echo 'case $- in
    *i*) ;;
      *) return;;
esac
echo "WELCOME TO DEV PHP DOCKER IMG shell session."
echo "In order to run a php script with xdebug disabled use the php_no_xdebug command."

#Aliases
alias php_no_xdebug="php -d dxdebug.mode=off"
' >>  ${WWW_HOME}/.bashrc;
chown ${WEB_USER}:${WEB_USER} ${WWW_HOME}/.bashrc
chmod 644 ${WWW_HOME}/.bashrc

echo "Installing certificates"

if [ -f "/etc/ca-certificates.conf.orig" ]; then
  cp /etc/ca-certificates.conf.orig /etc/ca-certificates.conf
fi

for cert in /usr/local/share/cert_install/*; do
  
  echo "Checking $cert"
  openssl x509 -in $cert -text -noout 2>&1 > /dev/null
  if [ ! $? ]  ; then 
    continue;
  fi

  base_certname=$(basename $cert)
  base_certname="${base_certname%%.*}.crt"

  cp $cert /usr/share/ca-certificates/$base_certname
  echo $base_certname >> /etc/ca-certificates.conf
done

update-ca-certificates

echo "Configure SSH Client"
if [ -d "${WWW_HOME}/.ssh_settings" ]; then
  ls -l "${WWW_HOME}/.ssh_settings"
  mkdir -p ${WWW_HOME}/.ssh
  cp ${WWW_HOME}/.ssh_settings/*  ${WWW_HOME}/.ssh/
fi

if [ -d "${WWW_HOME}/.ssh" ]; then
  chown -R ${WEB_USER}:${WEB_USER} ${WWW_HOME}/.ssh
  chmod 600 ${WWW_HOME}/.ssh/*
fi

echo "Launch application"
exec "$@"