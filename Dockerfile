FROM alpine:3.12

ENV PHP_VERSION=7.4.9-r0 \
   PHP_IGBINARY_VERSION=3.1.5-r0 \
   PHP_MCRYPT_VERSION=1.0.3-r2 \
   PHP_MEMCACHED_VERSION=3.1.5-r2 \
   PHP_REDIS_VERSION=5.3.1-r0 \
   PHP_AMQP_VERSION=1.10.2-r1 \
   PHP_MONGODB_VERSION=1.8.0-r0

ENV PHP_MEMORY_LIMIT=256M \
   PHP_PRECISION=-1 \
   PHP_OUTPUT_BUFFERING=4096 \
   PHP_SERIALIZE_PRECISION=-1 \
   PHP_MAX_EXECUTION_TIME=60 \
   PHP_ERROR_REPORTING=E_ALL \
   PHP_DISPLAY_ERRORS=0 \
   PHP_DISPLAY_SARTUP_ERRORS=0 \
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
   PHP_SESSION_USE_COOKIES=1 \
   PHP_SESSION_COOKIE_LIFETIME=0 \
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
   PHP_IGBINARY_COMPACT_STRINGS=1 \
   PHP_PM=ondemand \
   PHP_PM_MAX_CHILDREN=100 \
   PHP_PM_START_SERVERS=20 \
   PHP_PM_MIN_SPARE_SERVERS=20 \
   PHP_PM_MAX_SPARE_SERVERS=20 \
   PHP_PM_PROCESS_IDLE_TIMEOUT=60s \
   PHP_PM_MAX_REQUESTS=500

RUN apk upgrade --update --no-cache && \
    apk add --update --no-cache \
    ca-certificates \
    curl \
    bash

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk add --update --no-cache libmemcached rabbitmq-c libzip

RUN apk add --update --no-cache \
        php7-pecl-igbinary=${PHP_IGBINARY_VERSION} \
        php7-pecl-mcrypt=${PHP_MCRYPT_VERSION} \
        php7-pecl-mongodb=${PHP_MONGODB_VERSION} \
        php7-pecl-memcached=${PHP_MEMCACHED_VERSION} \
        php7-pecl-redis=${PHP_REDIS_VERSION} \
        php7-pecl-amqp=${PHP_AMQP_VERSION} \
        php7-common=${PHP_VERSION} \
        php7-bcmath=${PHP_VERSION} \
        php7-bz2=${PHP_VERSION} \
        php7-calendar=${PHP_VERSION} \
        php7-ctype=${PHP_VERSION} \
        php7-curl=${PHP_VERSION} \
        php7-dom=${PHP_VERSION} \
        php7-enchant=${PHP_VERSION} \
        php7-exif=${PHP_VERSION} \
        php7-fileinfo=${PHP_VERSION} \
        php7-ftp=${PHP_VERSION} \
        php7-gd=${PHP_VERSION} \
        php7-gettext=${PHP_VERSION} \
        php7-gmp=${PHP_VERSION} \
        php7-iconv=${PHP_VERSION} \
        php7-imap=${PHP_VERSION} \
        php7-intl=${PHP_VERSION} \
        php7-json=${PHP_VERSION} \
        php7-ldap=${PHP_VERSION} \
        php7-litespeed=${PHP_VERSION} \
        php7-mbstring=${PHP_VERSION} \
        php7-mysqli=${PHP_VERSION} \
        php7-mysqlnd=${PHP_VERSION} \
        php7-odbc=${PHP_VERSION} \
        php7-opcache=${PHP_VERSION} \
        php7-openssl=${PHP_VERSION} \
        php7-pcntl=${PHP_VERSION} \
        php7-pdo=${PHP_VERSION} \
        php7-pdo_dblib=${PHP_VERSION} \
        php7-pdo_mysql=${PHP_VERSION} \
        php7-pdo_odbc=${PHP_VERSION} \
        php7-pdo_pgsql=${PHP_VERSION} \
        php7-pdo_sqlite=${PHP_VERSION} \
        php7-pear=${PHP_VERSION} \
        php7-pgsql=${PHP_VERSION} \
        php7-phar=${PHP_VERSION} \
        php7-phpdbg=${PHP_VERSION} \
        php7-posix=${PHP_VERSION} \
        php7-pspell=${PHP_VERSION} \
        php7-session=${PHP_VERSION} \
        php7-shmop=${PHP_VERSION} \
        php7-simplexml=${PHP_VERSION} \
        php7-snmp=${PHP_VERSION} \
        php7-soap=${PHP_VERSION} \
        php7-sockets=${PHP_VERSION} \
        php7-sodium=${PHP_VERSION} \
        php7-sqlite3=${PHP_VERSION} \
        php7-sysvmsg=${PHP_VERSION} \
        php7-sysvsem=${PHP_VERSION} \
        php7-sysvshm=${PHP_VERSION} \
        php7-tidy=${PHP_VERSION} \
        php7-tokenizer=${PHP_VERSION} \
        php7-xml=${PHP_VERSION} \
        php7-xmlreader=${PHP_VERSION} \
        php7-xmlrpc=${PHP_VERSION} \
        php7-xmlwriter=${PHP_VERSION} \
        php7-xsl=${PHP_VERSION} \
        php7-zip=${PHP_VERSION} \
        php7-fpm=${PHP_VERSION} \
        php7=${PHP_VERSION}

RUN rm -rf /etc/php7/php.ini && \
    mkdir /var/www

COPY ./conf/php.ini /etc/php7/php.ini
COPY ./conf/www.conf /etc/php7/php-fpm.d/www.conf
COPY ./conf/php-fpm.conf /etc/php7/php-fpm.conf

RUN addgroup -g 1000 -S www-data && \
        adduser -u 1000 -D -S -h /var/www -s /sbin/nologin -G www-data www-data && \
        touch /var/spool/cron/crontabs/www-data && \
        chown www-data:www-data /var/spool/cron/crontabs/www-data

WORKDIR /var/www
USER www-data

EXPOSE 9000
CMD ["/usr/sbin/php-fpm7"]
