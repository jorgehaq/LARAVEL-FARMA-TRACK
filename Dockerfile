FROM php:8.2-fpm

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl

# Instalar extensiones PHP
RUN docker-php-ext-install pdo pdo_mysql zip exif pcntl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configurar directorio de trabajo
WORKDIR /var/www/html

# Copiar código
COPY . /var/www/html

# Instalar dependencias de Composer
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Configurar permisos
RUN chown -R www-data:www-data /var/www/html

CMD php artisan serve --host=0.0.0.0 --port=8000

EXPOSE 8000
