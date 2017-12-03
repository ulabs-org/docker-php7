FROM alpine:edge

ENV TERM xterm

ENV PHP_MEMORY_LIMIT=256M \
   PHP_ERROR_REPORTING=E_ALL \
   PHP_DISPLAY_ERRORS=0 \
   PHP_DISPLAY_STARTUP_ERRORS=0 \
   PHP_TRACK_ERRORS=0 \
   PHP_LOG_ERRORS=1 \
   PHP_LOG_ERRORS_MAX_LEN=10240 \
   PHP_POST_MAX_SIZE=20M \
   PHP_MAX_UPLOAD_FILESIZE=10M \
   PHP_MAX_FILE_UPLOADS=20 \
   PHP_MAX_INPUT_TIME=60 \
   PHP_DATE_TIMEZONE=Europe/Minsk \
   PHP_VARIABLES_ORDER=EGPCS \
   PHP_REQUEST_ORDER=GP \
   PHP_SESSION_SERIALIZE_HANDLER=php_binary \
   PHP_SESSION_SAVE_HANDLER=files \
   PHP_SESSION_SAVE_PATH=/tmp \
   PHP_SESSION_GC_PROBABILITY=1 \
   PHP_SESSION_GC_DIVISOR=10000 \
   PHP_OPCACHE_ENABLE=1 \
   PHP_OPCACHE_ENABLE_CLI=0 \
   PHP_OPCACHE_MEMORY_CONSUMPTION=128 \
   PHP_OPCACHE_INTERNED_STRINGS_BUFFER=32 \
   PHP_OPCACHE_MAX_ACCELERATED_FILES=10000 \
   PHP_OPCACHE_USE_CWD=1 \
   PHP_OPCACHE_VALIDATE_TIMESTAMPS=1 \
   PHP_OPCACHE_REVALIDATE_FREQ=2 \
   PHP_OPCACHE_ENABLE_FILE_OVERRIDE=0 \
   PHP_ZEND_ASSERTIONS=-1 \
   PHP_IGBINARY_COMPACT_STRINGS=1

RUN apk add --no-cache \
    ca-certificates \
    curl \
    bash

ENV PHP_VERSION=7.1.12-r0 \
    IMAGICK_VERSION=3.4.3-r3 \
    MONGODB_VERSION=1.3.1-r0 

RUN set -x \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk add --no-cache \
        php7-session=${PHP_VERSION} \
        php7-mcrypt=${PHP_VERSION} \
        php7-soap=${PHP_VERSION} \
        php7-openssl=${PHP_VERSION} \
        php7-gmp=${PHP_VERSION} \
        php7-pdo_odbc=${PHP_VERSION} \
        php7-json=${PHP_VERSION} \
        php7-dom=${PHP_VERSION} \
        php7-pdo=${PHP_VERSION} \
        php7-zip=${PHP_VERSION} \
        php7-mysqli=${PHP_VERSION} \
        php7-sqlite3=${PHP_VERSION} \
        php7-pdo_pgsql=${PHP_VERSION} \
        php7-bcmath=${PHP_VERSION} \
        php7-gd=${PHP_VERSION} \
        php7-odbc=${PHP_VERSION} \
        php7-pdo_mysql=${PHP_VERSION} \
        php7-pdo_sqlite=${PHP_VERSION} \
        php7-gettext=${PHP_VERSION} \
        php7-xmlreader=${PHP_VERSION} \
        php7-xmlwriter=${PHP_VERSION} \
        php7-xmlrpc=${PHP_VERSION} \
        php7-xml=${PHP_VERSION} \
        php7-simplexml=${PHP_VERSION} \
        php7-bz2=${PHP_VERSION} \
        php7-iconv=${PHP_VERSION} \
        php7-pdo_dblib=${PHP_VERSION} \
        php7-curl=${PHP_VERSION} \
        php7-ctype=${PHP_VERSION} \
        php7-pcntl=${PHP_VERSION} \
        php7-posix=${PHP_VERSION} \
        php7-phar=${PHP_VERSION} \
        php7-opcache=${PHP_VERSION} \
        php7-mbstring=${PHP_VERSION} \
        php7-zlib=${PHP_VERSION} \
        php7-fileinfo=${PHP_VERSION} \
        php7-tokenizer=${PHP_VERSION} \
        php7-exif=${PHP_VERSION} \
        php7-imagick=${IMAGICK_VERSION} \
        php7-mongodb=${MONGODB_VERSION} \
        php7-fpm=${PHP_VERSION} \
        php7=${PHP_VERSION} \
        git \
        less \
        nano \
        unzip \
        openssh \
        rabbitmq-c \
        imagemagick \
        libmemcached

# https://github.com/igbinary/igbinary
# https://github.com/php-memcached-dev/php-memcached
# https://github.com/phpredis/phpredis
# https://github.com/pdezwart/php-amqp
ENV REDIS_VERSION=3.1.4 \
    MEMCACHED_VERSION=3.0.4 \
    IGBINARY_VERSION=2.0.5 \
    AMPQ_VERSION=1.9.3

RUN apk add --no-cache --virtual .build-deps git file re2c autoconf make g++ php7-dev=${PHP_VERSION} libmemcached-dev cyrus-sasl-dev zlib-dev musl rabbitmq-c-dev pcre-dev && \
    git clone --depth=1 -b ${IGBINARY_VERSION} https://github.com/igbinary/igbinary.git /tmp/php-igbinary && \
    cd /tmp/php-igbinary && \
    phpize && ./configure CFLAGS="-O2 -g" --enable-igbinary && make && make install && \
    cd .. && rm -rf /tmp/php-igbinary/ && \
    echo 'extension=igbinary.so' >> /etc/php7/conf.d/igbinary.ini && \
    \
    git clone --depth=1 -b v${MEMCACHED_VERSION} https://github.com/php-memcached-dev/php-memcached.git /tmp/php-memcached && \
    cd /tmp/php-memcached && \
    phpize && ./configure --disable-memcached-sasl && make && make install && \
    cd .. && rm -rf /tmp/php-memcached/ && \
    echo 'extension=memcached.so' >> /etc/php7/conf.d/memcached.ini && \
    \
    git clone --depth=1 -b ${REDIS_VERSION} https://github.com/phpredis/phpredis.git /tmp/php-redis && \
    cd /tmp/php-redis && \
    phpize &&  ./configure --enable-redis-igbinary && make && make install && \
    cd .. && rm -rf /tmp/php-redis/ && \
    echo 'extension=redis.so' >> /etc/php7/conf.d/redis.ini && \
    \
    git clone --depth=1 -b v${AMPQ_VERSION} https://github.com/pdezwart/php-amqp.git /tmp/php-amqp && \
    cd /tmp/php-amqp && \
    phpize && ./configure && make && make install && \
    cd .. && rm -rf /tmp/php-amqp/ && \
    echo 'extension=amqp.so' >> /etc/php7/conf.d/amqp.ini && \
    \
    apk del .build-deps

RUN rm -rf /etc/php7/php.ini \
    && mkdir /webapp \
    && mkdir /usr/local/phar \
    && curl -sSL https://getcomposer.org/composer.phar -o /usr/local/phar/composer.phar \
    && chmod +x /usr/local/phar/composer.phar

COPY ./bin/ /usr/bin/
COPY ./conf/php.ini /etc/php7/php.ini
COPY ./conf/www.conf /etc/php7/php-fpm.d/www.conf
COPY ./conf/php-fpm.conf /etc/php7/php-fpm.conf

WORKDIR /webapp

EXPOSE 9000
CMD ["/usr/sbin/php-fpm7", "-R"]