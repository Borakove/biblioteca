FROM php:8.2-fpm-alpine

RUN docker-php-ext-install mysqli

RUN apk add --no-cache nginx

COPY . /var/www/html/

RUN mkdir -p /run/nginx

RUN printf 'server {\n\
    listen 80;\n\
    root /var/www/html;\n\
    index index.php;\n\
    location / {\n\
        try_files $uri $uri/ /index.php?$query_string;\n\
    }\n\
    location ~ \\.php$ {\n\
        fastcgi_pass 127.0.0.1:9000;\n\
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;\n\
        include fastcgi_params;\n\
    }\n\
}\n' > /etc/nginx/http.d/default.conf

RUN printf '#!/bin/sh\n\
php-fpm -D\n\
sleep 2\n\
echo "Iniciando nginx..."\n\
nginx -g "daemon off;" 2>&1\n' > /start.sh

RUN chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]