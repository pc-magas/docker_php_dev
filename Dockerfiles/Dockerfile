FROM php:8.1-fpm


ENV PHP_CONF_DIR="$PHP_INI_DIR/conf.d" \
    PHP_SETTINGS="$PHP_INI_DIR/php.ini"\
    FPM_CONF_DIR="/usr/local/etc/php-fpm.d"\
    DOCKER_UID=1000 \
    DOCKER_GID=1000 \
    XDEBUG_CONF_FILE=${PHP_CONF_DIR}/docker-php-ext-xdebug.ini \
    XDEBUG_HOST="" \
    XDEBUG_IDE_KEY="" \
    XDEBUG_PORT=9000 \
    XDEBUG_DBGP=FALSE \
    COMPOSER_MEMORY_LIMIT=-1

# We want for development easyness
RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions


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
     xsl