FROM php:8.1-fpm


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
    COMPOSER_MEMORY_LIMIT=-1

env XDEBUG_CONF_FILE=${PHP_CONF_DIR}/docker-php-ext-xdebug.ini

# Install Base tools
RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions &&\
    php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');" &&\
    php /tmp/composer-setup.php --install-dir=/bin --filename=composer &&\
    rm -rf /tmp/composer-setup.php &&\
    chmod +x /bin/composer &&\
    install-php-extensions xdebug &&\
    mkdir -p /var/log/xdebug &&\
    DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install net-tools &&\
    echo "zend_extension=xdebug" >> ${XDEBUG_CONF_FILE} &&\
    echo "[xdebug]" >> ${XDEBUG_CONF_FILE} &&\
    echo "xdebug.mode = debug,develop" >> ${XDEBUG_CONF_FILE} &&\
    echo "xdebug.max_nesting_level = 1000" >> ${XDEBUG_CONF_FILE} &&\
    echo "xdebug.log = /var/log/xdebug/xdebug.log" >> ${XDEBUG_CONF_FILE} &&\
    echo "xdebug.discover_client_host=true" >> ${XDEBUG_CONF_FILE} &&\
    cp ${XDEBUG_CONF_FILE} ${XDEBUG_CONF_FILE}.orig &&\
    apt-get autoremove && apt-get autoclean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* cache/* /var/lib/log/*

VOLUME /var/log/xdebug

# INSTALL PHP MODULES HERE
RUN install-php-extensions\
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

# Place rest settings here


# Do not edit bellow this line

COPY ./utils/entrypoint.sh  /usr/local/bin/entrypoint.sh
COPY ./utils/test_xdebug.php /bin/test_xdebug

RUN chmod +x /bin/test_xdebug &&\
    chown root:root /bin/test_xdebug &&\
    chown root:root /usr/local/bin/entrypoint.sh &&\
    chmod +x /usr/local/bin/entrypoint.sh &&\
    usermod --shell /bin/bash www-data

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm"]