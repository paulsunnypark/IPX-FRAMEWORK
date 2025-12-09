FROM php:8.4-fpm-alpine

# 시스템 패키지 설치
RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    oniguruma-dev \
    postgresql-dev \
    icu-dev \
    autoconf \
    g++ \
    make \
    linux-headers

# PHP 확장 설치
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        mysqli \
        gd \
        zip \
        mbstring \
        exif \
        pcntl \
        bcmath \
        opcache \
        intl

# Redis 확장 설치
RUN pecl install redis && docker-php-ext-enable redis

# Composer 설치
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# PHP 설정
RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.memory_consumption=256" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.interned_strings_buffer=16" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.max_accelerated_files=20000" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.validate_timestamps=0" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.jit_buffer_size=256M" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.jit=tracing" >> /usr/local/etc/php/conf.d/opcache.ini

# 작업 디렉토리 설정
WORKDIR /var/www/html

# 권한 설정
RUN chown -R www-data:www-data /var/www/html

USER www-data

