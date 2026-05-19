FROM php:8.2-fpm-alpine

RUN docker-php-ext-install mysqli

RUN apk add --no-cache nginx

RUN mkdir -p /run/nginx

COPY . /var/www/html/

COPY nginx.conf /etc/nginx/http.d/default.conf

COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]