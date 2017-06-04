FROM php:7.0-apache

RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends libgraphicsmagick1-dev libpng12-dev libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

RUN pecl install gmagick-2.0.4RC1 \
    && docker-php-ext-enable gmagick \
    && rm -rf /tmp/pear

RUN { \
      echo '<Directory /var/www/html>'; \
      echo '  RewriteEngine on'; \
      echo '  RewriteCond %{REQUEST_FILENAME} !-f'; \
      echo '  RewriteRule .* /index.php [L,QSA]'; \
      echo '</Directory>'; \
    } >> /etc/apache2/conf-available/photon.conf

RUN a2enmod rewrite

RUN a2enconf photon
