FROM php:8.2-fpm-alpine

# Set working directory
WORKDIR /var/www

# Install system dependencies
RUN apk update && apk add --no-cache \
    git \
    curl \
    libzip-dev \
    zip \
    nginx

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql zip bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy application code
COPY . /var/www

# Set file permissions
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www/storage /var/www/bootstrap/cache

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy Nginx configuration
COPY docker/nginx/default.conf /etc/nginx/http.d/default.conf

# Expose port 80 for Nginx
EXPOSE 80

# Set entrypoint to start PHP-FPM and Nginx
ENTRYPOINT ["/bin/sh", "-c", "php-fpm82 -D && nginx -g 'daemon off;'"]

# Switch user to www-data for application execution
USER www-data
