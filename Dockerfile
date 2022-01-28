FROM phpmyfaq/phpmyfaq

WORKDIR /faq
COPY . .
RUN tar -zxvf files_phpmyfaq-3.0.12.tar.gz \
	&& mkdir -p phpmyfaq/attachments \
	&& mkdir -p phpmyfaq/data \
	&& mkdir -p phpmyfaq/images \
	&& cp -rf phpmyfaq/. /var/www/html/ \
	&& chmod -R 777 /var/www/html/*

WORKDIR /var/www/html
RUN rm -rf /faq