FROM alpine:3.9

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
   PHP_DATE_TIMEZONE=Europe/Moscow \
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
        bash \
        git \
        less \
        nano \
        unzip \
        openssh \
        imagemagick \
# PHP:
        php7-session \
        php7-pecl-mcrypt \
        php7-soap \
        php7-openssl \
        php7-gmp \
        php7-pdo_odbc \
        php7-json \
        php7-dom \
        php7-pdo \
        php7-zip \
        php7-mysqli \
        php7-sqlite3 \
        php7-pdo_pgsql \
        php7-bcmath \
        php7-gd \
        php7-odbc \
        php7-pdo_mysql \
        php7-pdo_sqlite \
        php7-gettext \
        php7-xmlreader \
        php7-xmlwriter \
        php7-xmlrpc \
        php7-xml \
        php7-simplexml \
        php7-bz2 \
        php7-iconv \
        php7-intl \
        php7-pdo_dblib \
        php7-curl \
        php7-ctype \
        php7-pcntl \
        php7-posix \
        php7-phar \
        php7-opcache \
        php7-mbstring \
        php7-zlib \
        php7-fileinfo \
        php7-tokenizer \
        php7-exif \
        php7-pecl-imagick \
        php7-pecl-mongodb \
        php7-fpm \
        php7-pecl-redis \
        php7-pecl-memcached \
        php7-pecl-amqp \
        php7-pecl-gmagick \
        php7-pecl-igbinary \
        php7

# SEGFAULT:
RUN set -x \
    && apk del php7-pecl-gmagick \
    && rm -rf /etc/php7/conf.d/gmagick.ini

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