FROM alpine:3.13 AS baseimage

WORKDIR /var/www/html/

# Essentials
RUN echo "UTC" > /etc/timezone
RUN apk add --no-cache zip unzip curl sqlite nginx python3-dev python3 mc nano supervisor

# Installing bash
RUN apk add bash
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Installing PHP
RUN apk add --no-cache php8 \
    php8-common \
    php8-fpm \
    php8-pdo \
    php8-opcache \
    php8-zip \
    php8-phar \
    php8-iconv \
    php8-cli \
    php8-curl \
    php8-openssl \
    php8-mbstring \
    php8-tokenizer \
    php8-fileinfo \
    php8-json \
    php8-xml \
    php8-xmlwriter \
    php8-simplexml \
    php8-dom \
    php8-pdo_mysql \
    php8-pdo_sqlite \
    php8-tokenizer \
    php8-pecl-redis

RUN ln -s /usr/bin/php8 /usr/bin/php

# Installing composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm -rf composer-setup.php

# Configure supervisor
RUN mkdir -p /etc/supervisor.d/
COPY .docker/supervisord.ini /etc/supervisor.d/supervisord.ini

# Configure PHP
RUN mkdir -p /run/php/
RUN touch /run/php/php8.0-fpm.pid
RUN touch /var/run/php8-fpm.sock
RUN chown nobody.nobody /var/run/php8-fpm.sock

COPY .docker/php-fpm.conf /etc/php8/php-fpm.conf
COPY .docker/php.ini-production /etc/php8/php.ini

# Configure nginx
COPY .docker/nginx.conf /etc/nginx/
COPY .docker/nginx-laravel.conf /etc/nginx/http.d/default.conf

RUN mkdir -p /run/nginx/
RUN touch /run/nginx/nginx.pid

# Log files setting
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log


# Building process
COPY . .

RUN composer install --no-dev
RUN mkdir /var/www/html/storage
RUN chown -R nobody:nobody /var/www/html/public
RUN rm -rf .docker Dockerfile

EXPOSE 8000
CMD ["supervisord", "-c", "/etc/supervisor.d/supervisord.ini"]