#!/usr/bin/env bash

XDEBUG_VERSION="$(echo "${XDEBUG_VERSION}" | tr -d '[:space:]')"

if [ -z ${XDEBUG_VERSION} ] && [ "${XDEBUG_VERSION}" != "" ] && [ "${XDEBUG_VERSION}" != "latest" ] ; then
    echo "Installing xdebug version ${XDEBUG_VERSION}"
    install-php-extensions xdebug-${XDEBUG_VERSION}
else
    echo "Installing xdebug latest version"
    PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
    PHP_VERSION="$(echo "${PHP_VERSION}" | tr -d '[:space:]')"

    case "${PHP_VERSION}" in 
     "7.1")install-php-extensions xdebug-2.9.8;;
     "7.0")install-php-extensions xdebug-2.7.2;;
     "5.6"|"5.5")install-php-extensions xdebug-2.5.5;;
     "5.4")install-php-extensions xdebug-2.4.1;;
     "5.3")install-php-extensions xdebug-2.2.6;;
     *) install-php-extensions xdebug;;
    esac
fi

mkdir -p /var/log/xdebug
touch /var/log/xdebug/xdebug.log
chown -R www-data:www-data /var/log/xdebug
chmod 666 -R /var/log/xdebug