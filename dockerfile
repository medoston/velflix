#
# PHP Dependencies
#
FROM composer:2.2.6 as vendor
 
COPY composer.json composer.json
COPY composer.lock composer.lock
 
RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist

RUN php artisan key:generate
 
#
# Frontend
#
FROM node as frontend
 
COPY package.json webpack.mix.js yarn.lock
 
RUN npm install && npm run build
 
#
# Application
#
FROM php:8.0.17-fpm-alpine3.15
 
COPY . 

RUN php artisan migrate
RUN php artisan db:seed
RUN php artisan serve