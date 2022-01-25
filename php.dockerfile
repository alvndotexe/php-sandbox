FROM php:8.0-fpm

ARG uid
ARG user

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    vim \
    unzip

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-install mysqli

#Nicer errors
RUN pecl install xdebug && docker-php-ext-enable xdebug

# installs composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

#adds user for composer
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user \

# installs packages
RUN composer update

# Set working directory
WORKDIR /var/www

USER $user

EXPOSE 9000
