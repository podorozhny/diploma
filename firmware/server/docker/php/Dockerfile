FROM php:7.0-fpm

MAINTAINER Ivan Podorozhny <ivan@podorozhny.ru>

RUN apt-get update

RUN apt-get install -y libmcrypt-dev libpq-dev netcat

RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install zip
RUN docker-php-ext-install opcache
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_pgsql

RUN yes | pecl install apcu

RUN echo "extension=$(find /usr/local/lib/php/extensions/ -name apcu.so)" > /usr/local/etc/php/conf.d/apcu.ini

RUN yes | pecl install xdebug-beta

RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/xdebug.ini

COPY ./docker/php/config/ /usr/local/etc/
COPY ./docker/php/start.sh /start.sh

RUN update-ca-certificates --fresh

WORKDIR /application

CMD ["/bin/bash", "/start.sh"]
