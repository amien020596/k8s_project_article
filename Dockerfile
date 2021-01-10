# FROM php:7.4-fpm

# COPY composer.lock composer.json /var/www/html/

# ENV DOCKERIZE_VERSION 0.6.1

# # Install dockerize so we can wait for containers to be ready
# RUN curl -s -f -L -o /tmp/dockerize.tar.gz https://github.com/jwilder/dockerize/releases/download/v$DOCKERIZE_VERSION/dockerize-linux-amd64-v$DOCKERIZE_VERSION.tar.gz \
#   && tar -C /usr/local/bin -xzvf /tmp/dockerize.tar.gz \
#   && rm /tmp/dockerize.tar.gz

# # Install nodejs
# RUN curl -sL https://deb.nodesource.com/setup_12.x | bash

# RUN apt-get update \
#   && apt-get install -y --no-install-recommends \
#   git \
#   vim \
#   libmemcached-dev \
#   libz-dev \
#   libpq-dev \
#   libjpeg-dev \
#   libpng-dev \
#   libfreetype6-dev \
#   libssl-dev \
#   libmcrypt-dev \
#   libzip-dev \
#   unzip \
#   zip \
#   nodejs \
#   && docker-php-ext-configure gd \
#   && docker-php-ext-configure zip \
#   && docker-php-ext-install \
#   gd \
#   exif \
#   opcache \
#   pdo_mysql \
#   pdo_pgsql \
#   pcntl \
#   zip \
#   && rm -rf /var/lib/apt/lists/*;

# # Install composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# COPY ./laravel.ini /usr/local/etc/php/conf.d/laravel.ini

# COPY . /var/www/html

# WORKDIR /var/www/html

# RUN pwd

# RUN cd /var/www/html

# RUN ls --all

# RUN composer install


FROM php:7.4-fpm

RUN docker-php-ext-install pdo_mysql
RUN apt-get update && apt-get install -y \
  libmcrypt-dev \
  vim \
  && docker-php-ext-install -j$(nproc) mcrypt \
  && docker-php-ext-install -j$(nproc) pdo

RUN apt-get install -y nginx nano supervisor && \
  rm -rf /var/lib/apt/lists/*

COPY . /var/www/html
WORKDIR /var/www/html

RUN rm /etc/nginx/sites-enabled/default

COPY /docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf

ADD https://getcomposer.org/download/1.6.2/composer.phar /usr/bin/composer
RUN chmod +rx /usr/bin/composer

RUN composer install

RUN cp .env.example .env
RUN php artisan key:generate

RUN chmod +x ./entrypoint

ENTRYPOINT ["./entrypoint"]

EXPOSE 80
