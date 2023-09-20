#!/bin/sh

WEB_USER="www-data"

usermod -u ${DOCKER_UID} ${WEB_USER}
groupmod -g ${DOCKER_GID} ${WEB_USER}


bash /bin/config_xdebug

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