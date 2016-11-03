Below you will find several examples to work with these images.

## Symfony application, Dockerfile.test
```
FROM docker1-registry.twobridges.io/nginx-php-fpm:7.0-test-0

COPY . /var/www/html

RUN cd /var/www/html \
 && chown -R app:app . \
 && rm -rf ./app/{cache,logs}/* \
 && chmod -R go-w . \
 && chmod -R g+w ./app/{cache,logs}
```

## Symfony application, Dockerfile
```
FROM docker1-registry.twobridges.io/nginx-php-fpm:7.0-0

ADD build/artifacts/package.tar.gz /var/www/html

RUN cd /var/www/html \
 && chown -R app:app . \
 && rm -rf ./app/{cache,logs}/* \
 && chmod -R go-w . \
 && chmod -R g+w ./app/{cache,logs}
```

## Zend Expressive application, Dockerfile.test
This example sets several environment variables which are used when running the test container; e.g. unittests.
```
FROM docker1-registry.twobridges.io/nginx-php-fpm:7.0-test-0

COPY . /var/www/html

RUN cd /var/www/html \
 && chown -R app:app . \
 && chmod -R go-w . \
 && chmod -R g+w data

ENV REDIS_SAM_SERVER=127.0.0.1
ENV REDIS_SAM_PORT=6379

ENV SWAGGER_URI=http://127.0.0.1/swagger.json

ENV NGX_DOCUMENT_ROOT=/var/www/html/public
ENV NGX_PHP_FRONT_CONTROLLER=index.php
```

## Zend Expressive application, Dockerfile
The Dockerfile of the same application as above, without the required testing environment variables
```
FROM docker1-registry.twobridges.io/nginx-php-fpm:7.0-0

ADD build/artifacts/artifact.tar.gz /var/www/html

RUN cd /var/www/html \
 && chown -R app:app . \
 && chmod -R go-w . \
 && chmod -R g+w data

ENV NGX_DOCUMENT_ROOT=/var/www/html/public
ENV NGX_PHP_FRONT_CONTROLLER=index.php
```
