#!/bin/sh
php-fpm -D
sleep 2
nginx -g "daemon off;"