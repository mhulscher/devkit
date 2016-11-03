FROM centos:7

MAINTAINER systeembeheer@nepworldwide.nl

# Install required Software

RUN yum -y install curl \

# Install repositories

## epel

 && yum -y install epel-release \
 && yum -y install epel-release \

## ius

 && yum -y install https://centos7.iuscommunity.org/ius-release.rpm \

## nginx

 && rpm --import http://nginx.org/keys/nginx_signing.key \
 && echo '
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/centos/7/x86_64/
gpgcheck=1
gpgkey=http://nginx.org/keys/nginx_signing.key
enabled=1' > /etc/yum.repos.d/nginx.repo \

## mongodb

 && rpm --import https://www.mongodb.org/static/pgp/server-3.2.asc \
 && echo '
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc
' > /etc/yum.repos.d/mongodb.repo \

## elastic

 && rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch \
 && echo '
[elasticsearch-5.x]
name=Elasticsearch repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
' > /etc/yum.repos.d/elastic.repo \

## nodejs

 && curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - \

# Install additional software

 && yum -y install \
    wget \
    git \
    rsync \
 && curl -Lo /usr/bin/confd https://github.com/kelseyhightower/confd/releases/download/v0.12.0-alpha3/confd-0.12.0-alpha3-linux-amd64 \
 && chmod +x /usr/bin/confd \

# Install Toolchains

## php

 && yum -y install \
    php70u-fpm \
    php70u-cli \
    php70u-common \
    php70u-fpm \
    php70u-imap \
    php70u-intl \
    php70u-json \
    php70u-ldap \
    php70u-mbstring \
    php70u-mcrypt \
    php70u-mysqlnd \
    php70u-opcache \
    php70u-pecl-redis \
    php70u-pecl-xdebug \
    php70u-pdo \
    php70u-process \
    php70u-recode \
    php70u-tidy \
    php70u-twig \
    php70u-xml \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin \
  && mv /usr/bin/composer.phar /usr/bin/composer \
  && chmod +x /usr/bin/composer \

## java

 && yum -y install java-1.8.0-openjdk-devel ant maven \

## nodejs

 && yum -y install nodejs-devel \
 && npm install -g grunt gulp bower yarn apidoc jspm phantomjs \

## ruby

 && yum -y install ruby ruby-devel ruby-gem \
 && gem install --no-document compass sass \

## python

 && yum -y install python35u python35u-devel python35u-pip \

## standard devtools

 && yum -y groupinstall "Development Tools" \

# Install services

## nginx

 && yum -y install nginx \
 && rm -rf /etc/nginx/conf.d/* \
 && mkdir -pv /var/www/html/web \

## php-fpm

 && rm -f /etc/php-fpm.d/* \

## redis

 && yum -y install redis32u \

## mariadb

 && yum -y install mariadb101u-server \

## mongodb

 && yum -y install mongodb-org \

## elasticsearch

 && yum -y install elasticsearch \

## x framebuffer

 && yum -y install xvfb \

# install configuration files

COPY confd                       /etc/confd
COPY nginx/nginx.conf            /etc/nginx/nginx.conf
COPY nginx/001-logformat.conf    /etc/nginx/conf.d/001-logformat.conf
COPY php/php.ini                 /etc/php.ini
COPY php/php-fpm.conf            /etc/php-fpm.conf
COPY php/www.conf                /etc/php-fpm.d/www.conf

COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 80 443 3306 6379
ENTRYPOINT /entrypoint.sh
