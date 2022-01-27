FROM phpmyfaq/phpmyfaq

# composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# yarn
RUN apt update \
    && apt install -y nodejs gnupg2 \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt update \
    && apt install -y yarn \
    && rm -rf /var/lib/apt/lists/*

# phpmyfaq
WORKDIR /faq
COPY phpMyFAQ-3.0.12.tar.gz .
RUN tar -zxvf phpMyFAQ-3.0.12.tar.gz \
    && rm -f phpMyFAQ-3.0.12.tar.gz \
    && cd phpMyFAQ-3.0.12 \
    && composer install \
    && yarn install \
    && yarn build \
    && mkdir attachments config data images

RUN cp -rf /faq/phpMyFAQ-3.0.12/. /var/www/html/ \
    && rm -rf /faq \
    && chmod -R 777 /var/www/html/*

WORKDIR /var/www/html