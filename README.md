# Development kit

This docker image contains several development toolchains and services that can
be used to build and test software. It is based on a CentOS 7 base image.

## Toolchains

The following components are installed:

Software | Version | Extra
---|---|---
php | 7 | composer, modules: bcmath, gd, imap, intl, json, ldap, mbstring, mcrypt, mysqlnd, odbc, amqp, apcu, redis, pdo, process, recode, soap, tidy, twig, xml, xmlrpc
java | openjdk 8 | ant, maven
nodejs | 6 | npm, grunt, gulp, bower, yarn, apidoc, jspm, phantomjs
ruby  | 2.0 | compass, sass
python | 3.5 |
c / c++ | |
standard development tools | |

## Services

The following services can be started prior to the execution of your command by
defining them in the `START_SERVICES` environment variable. For example, running
the image with the following configuration will start Redis, Nginx and PHP-FPM.

`START_SERVICES="redis nginx php-fpm"`

Software | Version | Add to `START_SERVICES`
---|---|---
nginx | mainline | nginx
php-fpm | 7.0 | php-fpm
redis | 3.2 | redis
mariadb | 10.1 | mariadb
mongodb | 3.2 | mongodb
elasticsearch | 5.0 | elasticsearch
x framebuffer | | xvfb

## Additional

The following software is available as well.

| Software
| ---
| curl
| wget
| git
| rsync
| sonar-scanner
