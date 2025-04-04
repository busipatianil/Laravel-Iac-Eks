FROM php:8.1-fpm
WORKDIR /var/www

COPY . .

RUN apt-get update && apt-get install -y nginx supervisor unzip git curl \
    && docker-php-ext-install pdo_mysql

COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]