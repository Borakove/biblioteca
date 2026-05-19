FROM php:8.2-apache

RUN a2dismod mpm_event || true
RUN a2enmod mpm_prefork rewrite mysqli
RUN docker-php-ext-install mysqli

COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data

EXPOSE 80

CMD ["apache2-foreground"]