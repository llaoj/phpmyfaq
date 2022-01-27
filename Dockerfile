FROM php:8.0

# RUN apt-get update && apt-get install -y \
#         git \
#         libzip-dev \
#         zip \
#         unzip \
#         libfreetype6-dev \
#         libjpeg62-turbo-dev \
#         libpng-dev \
#         nginx \
#         supervisor

# RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
#     && docker-php-ext-install -j$(nproc) gd \
#     && docker-php-ext-install \
#         pdo_mysql \
#         bcmath \
#         zip \
#         exif

# RUN pecl install redis && docker-php-ext-enable redis
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
# RUN mkdir -p /root/.ssh/ && echo "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile /dev/null" > /root/.ssh/config

# COPY conf/php-user.ini $PHP_INI_DIR/conf.d/
# COPY conf/zz-user.conf $PHP_INI_DIR/../php-fpm.d/
# COPY conf/supervisor/ /etc/supervisor/conf.d/

# composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# yarn
RUN apt remove nodejs \
    && apt install -y nodejs gnupg2
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt update \
    && apt install -y yarn \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .
# COPY conf/nginx.conf /etc/nginx/conf.d/

# phpmyfaq
RUN tar -zxvf phpMyFAQ-3.0.12.tar.gz \
    && mv phpMyFAQ-3.0.12 phpmyfaq\
    && cd phpmyfaq \
    && composer install \
    && yarn install \
    && yarn build
