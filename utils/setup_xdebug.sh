#!/usr/bin/env bash

#
#  Xdebug setup Script
#  Copyright (C) 2023  Dimitrios Desyllas
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#


XDEBUG_VERSION="$(echo "${XDEBUG_VERSION}" | tr -d '[:space:]')"

if [ -z ${XDEBUG_VERSION} ] && [ "${XDEBUG_VERSION}" != "" ] && [ "${XDEBUG_VERSION}" != "latest" ] ; then
    echo "Installing xdebug version ${XDEBUG_VERSION}"
    install-php-extensions xdebug-${XDEBUG_VERSION}
else
    echo "Installing xdebug latest version"
    PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
    PHP_VERSION="$(echo "${PHP_VERSION}" | tr -d '[:space:]')"

    case "${PHP_VERSION}" in 
        "7.1")pecl install xdebug-2.9.8;;
        "7.0")pecl channel-update pecl.php.net;pecl install xdebug-2.7.2;;
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