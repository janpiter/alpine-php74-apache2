FROM alpine:latest

ARG TIMEZONE=Asia/Jakarta
WORKDIR /var/www/html/app

RUN apk add \
    --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community \
    --update-cache --repository http://dl-3.alpinelinux.org/alpine/v3.6/community \
    curl \
    git \
    zip \
    tzdata \
    nano \
    nodejs \
    npm \
    libmcrypt \
    libmcrypt-dev \
    mariadb-dev \
    apache2 \
    php7-dev \
    php7-apache2 \
    php7-fpm \
    php7-json \
    php7-phar \
    php7-openssl \
    php7-curl \
    php7-mcrypt \
    php7-pdo_mysql \
    php7-ctype \
    php7-gd \
    php7-xml \
    php7-dom \
    php7-iconv \
    php7-mysqli \
    php7-session \
    php7-mbstring \
    php7-intl \
    && ln -s /usr/bin/php7 /usr/bin/php \
    && curl -sS https://getcomposer.org/installer | \
       php -- --install-dir=/usr/local/bin --filename=composer \
    && mkdir -p /var/www/html/app \
    && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" >  /etc/timezone \
    && date \
    && rm -rf /var/cache/apk/*

COPY index.php .

RUN sed -i "s/#LoadModule rewrite_module modules\/mod_rewrite.so/LoadModule rewrite_module modules\/mod_rewrite.so/g" /etc/apache2/httpd.conf \
    && echo -e "<VirtualHost *:80>\n   DocumentRoot \"/var/www/html/app\"\n   SetEnv CI_ENV production\n   <Directory \"/var/www/html/app\">\n       DirectoryIndex index.php\n       Options Indexes MultiViews FollowSymLinks\n       AllowOverride All\n       Order allow,deny\n       Allow from all\n       Require all granted\n   </Directory>\n</VirtualHost>" >> /etc/apache2/httpd.conf \
    && sed -i 's/;extension=gd2/extension=gd2/g' /etc/php7/php.ini \
    && sed -i 's/;extension=intl/extension=intl/g' /etc/php7/php.ini \
    && sed -i 's/;extension=mbstring/extension=mbstring/g' /etc/php7/php.ini \
    && sed -i 's/;extension=mysqli/extension=mysqli/g' /etc/php7/php.ini \
    && sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 30M/g' /etc/php7/php.ini \
    && sed -i 's/post_max_size = 8M/post_max_size = 30M/g' /etc/php7/php.ini

CMD [ "/usr/sbin/httpd", "-D", "FOREGROUND" ]
