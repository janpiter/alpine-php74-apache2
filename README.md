# alpine-php74-apache2
Alpine based image for PHP 7.4 and Apache2.
- Apache 2.4.52
- PHP 7.4.27
- Composer 2.2.6
- Node.js v16.13.2
- Npm 8.1.3 
- Git 2.34.1


### DOCUMENT_ROOT:
```
/var/www/html/app
```


### Usage:

```
$ docker run --name php-apache -d -p 80:80 jpnkls/alpine-php74-apache2
```


### Mount your own app directory:

```
$ docker run \
  --name php-apache \
  -d \
  -p 80:80 \
  -v /path/to/my/app/dir:/var/www/html/app \
  jpnkls/alpine-php74-apache2
```


### Via docker-compose:

```
version: '2'

services:
  php-apache:
    image: jpnkls/alpine-php74-apache2
    container_name: php-apache
    ports:
      - "80:80"
    volumes:
      - /path/to/my/app/dir:/var/www/html/app
```