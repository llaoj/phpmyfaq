FROM php:8.0-fpm

RUN apt-get update && apt remove nodejs && apt-get install -y \
        git \
        libzip-dev \
        zip \
        unzip \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        nginx \
        supervisor \
        nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install \
        pdo_mysql \
        bcmath \
        zip \
        exif

RUN pecl install redis && docker-php-ext-enable redis
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN mkdir -p /root/.ssh/ && echo "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile /dev/null" > /root/.ssh/config

ADD conf/php-user.ini $PHP_INI_DIR/conf.d/
ADD conf/zz-user.conf $PHP_INI_DIR/../php-fpm.d/
ADD conf/supervisor/ /etc/supervisor/conf.d/

# composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# yarn
RUN curl -o- -L https://yarnpkg.com/install.sh | bash

WORKDIR /var/www/html

# phpmyfaq
RUN tar -zxvf ./phpMyFAQ-3.0.12.tar.gz \
    && cd phpMyFAQ-3.0.12 \
    && composer install \
    && yarn install \
    && yarn build \
    && cp nginx.conf /etc/nginx/conf.d/

CMD ["supervisord","-n"]
