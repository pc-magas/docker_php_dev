
ARG COMPOSER_VERSION=latest\
    PHP_VERSION=8.1 \
    NODE_VERSION=latest

# Uncomment line bellow for Nodejs support.
# FROM node:${NODE_VERSION} as node
FROM composer:${COMPOSER_VERSION} as composer
FROM php:${PHP_VERSION}-fpm

ENV PHP_CONF_DIR="$PHP_INI_DIR/conf.d" \
    PHP_SETTINGS="$PHP_INI_DIR/php.ini"\
    FPM_CONF_DIR="/usr/local/etc/php-fpm.d"\
    DOCKER_UID=1000 \
    DOCKER_GID=1000 \
    XDEBUG_HOST="" \
    XDEBUG_IDE_KEY="" \
    XDEBUG_PORT=9003 \
    XDEBUG_DBGP=FALSE \
    XDEBUG_ENABLE=FALSE \
    WWW_HOME="/home/www-data" \
    COMPOSER_MEMORY_LIMIT=-1

COPY ./utils/entrypoint.sh  /usr/local/bin/entrypoint.sh

RUN \
    chown root:root /usr/local/bin/entrypoint.sh &&\
    chmod +x /usr/local/bin/entrypoint.sh &&\
    mkdir ${WWW_HOME} &&\
    chown www-data:www-data ${WWW_HOME} &&\
    chmod -R 750 ${WWW_HOME} &&\
    usermod --shell /bin/bash --home ${WWW_HOME} www-data &&\
    cp /etc/ca-certificates.conf /etc/ca-certificates.conf.orig &&\
    mkdir -p /usr/local/share/cert_install

VOLUME /usr/local/share/cert_install
VOLUME ${WWW_HOME}

# INSTALL PHP MODULES HERE
RUN  --mount=type=bind,from=mlocati/php-extension-installer:latest,source=/usr/bin/install-php-extensions,target=/usr/local/bin/install-php-extensions \
     install-php-extensions\
     bcmath\
     ctype\
     curl\
     dom\ 
     fileinfo\ 
     filter\ 
     gd\ 
     hash\ 
     iconv\ 
     intl\ 
     json\ 
     libxml\ 
     openssl\ 
     mbstring\ 
     pcre\
     pdo pdo_mysql\
     simplexml\
     soap \
     sockets\
     sodium\
     spl\
     tokenizer\
     xmlwriter\
     xsl &&\
    apt-get autoremove && apt-get autoclean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* cache/* /var/lib/log/*

# Install composer & git
COPY --from=composer /usr/bin/composer /opt/composer
RUN --mount=type=bind,from=mlocati/php-extension-installer:latest,source=/usr/bin/install-php-extensions,target=/usr/local/bin/install-php-extensions \
    install-php-extensions zip &&\
    chown root:root /opt/composer &&\
    echo -e '#!/usr/bin/env sh\nphp -dxdebug.mode=off /opt/composer "$@"' | sed 's/-e\s*//g' > /bin/composer &&\
    chmod +x /bin/composer &&\
    DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y git &&\
    mkdir -p ${WWW_HOME}/.composer &&\
    chown www-data:www-data ${WWW_HOME}/.composer &&\
    apt-get autoremove && apt-get autoclean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* cache/* /var/lib/log/*

VOLUME ${WWW_HOME}/.composer

# Install Xdebug
ENV XDEBUG_CONF_FILE=${PHP_CONF_DIR}/docker-php-ext-xdebug.ini

ARG XDEBUG_VERSION="latest"

COPY ./utils/test_xdebug ./utils/get_xdebug_ip /bin/
COPY ./utils/setup_xdebug.php /tmp/setup_xdebug

RUN echo ${XDEBUG_VERSION} &&\
    php /tmp/setup_xdebug &&\
    rm -rf /tmp/setup_xdebug &&\
    rm -rf /tmp/xdebug &&\
    chown root:root /bin/test_xdebug &&\
    chmod +x /bin/test_xdebug &&\
    rm -rf /bin/setup_xdebug &&\
    apt-get autoremove && apt-get autoclean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* cache/* /var/lib/log/*

VOLUME /var/log/xdebug

# ***************************************************#
# Uncomment for nodejs (for example frontend builds) #
# ***************************************************#

# COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
# COPY --from=node /usr/local/bin/node /usr/local/bin/node

# RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm &&\
#     ln -s /usr/local/lib/node_modules/webpack-cli/bin/cli.js /usr/local/bin/webpack &&\
#     chown -R root:root /usr/local/lib/node_modules &&\
#     mkdir -p /var/www/.npm



ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm"]