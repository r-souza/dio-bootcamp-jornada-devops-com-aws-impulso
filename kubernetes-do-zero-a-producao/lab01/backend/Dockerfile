FROM php:7.4-apache

WORKDIR /var/www/html

RUN apt-get update && docker-php-ext-install pdo pdo_mysql mysqli

COPY index.php /var/www/html/
COPY conexao.php /var/www/html/

RUN chown -R www-data:www-data .

EXPOSE 80