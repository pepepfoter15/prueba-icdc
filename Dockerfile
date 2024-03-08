FROM debian:stable-slim

RUN sed -i 's/http:/https:/g' /etc/apt/sources.list.d/debian.sources
RUN echo 'Acquire::https::Verify-Peer "false";' > /etc/apt/apt.conf.d/99ignore-ssl-certificates

RUN apt-get update && apt-get install -y apache2 libapache2-mod-php php mariadb-client php-mysql && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN rm /var/www/html/index.html
COPY src /var/www/html/
COPY src/database.sql /opt/
RUN chown -R www-data:www-data /var/www/html

RUN a2enmod rewrite

EXPOSE 80

CMD apache2ctl -D FOREGROUND

ENV DB_HOST mariadb_p
ENV DB_NAME crud
ENV DB_USER crud
ENV DB_PASSWORD crud

COPY script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

CMD /usr/local/bin/script.sh
