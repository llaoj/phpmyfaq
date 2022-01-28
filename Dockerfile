FROM phpmyfaq/phpmyfaq

WORKDIR /var/www/html

COPY files_phpmyfaq-3.0.12.tar.gz .
RUN tar -zxvf files_phpmyfaq-3.0.12.tar.gz \
    && rm -f files_phpmyfaq-3.0.12.tar.gz \
    && mv phpmyfaq faq \
    && mkdir attachments data images \
    && chmod -R 777 /var/www/html/*