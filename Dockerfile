FROM centos:7

MAINTAINER mitch.hulscher@nepworldwide.nl

# Install required Software

RUN yum -y install curl bzip2 unzip sudo which \
 && sed -i 's/ requiretty/ !requiretty/g' /etc/sudoers \

# Install repositories

## epel

 && yum -y install epel-release \
 && yum -y install epel-release \

## ius

 && yum -y install https://centos7.iuscommunity.org/ius-release.rpm \

## nginx

 && rpm --import http://nginx.org/keys/nginx_signing.key \
 && echo -e '\
[nginx]\n\
name=nginx repo\n\
baseurl=http://nginx.org/packages/mainline/centos/7/x86_64/\n\
gpgcheck=1\n\
gpgkey=http://nginx.org/keys/nginx_signing.key\n\
enabled=1' > /etc/yum.repos.d/nginx.repo \

## mongodb

 && rpm --import https://www.mongodb.org/static/pgp/server-3.2.asc \
 && echo -e '\
[mongodb-org-3.2]\n\
name=MongoDB Repository\n\
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/\n\
gpgcheck=1\n\
enabled=1\n\
gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc\n\
' > /etc/yum.repos.d/mongodb.repo \

## elastic

 && rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch \
 && echo -e '\
[elasticsearch-5.x]\n\
name=Elasticsearch repository for 5.x packages\n\
baseurl=https://artifacts.elastic.co/packages/5.x/yum\n\
gpgcheck=1\n\
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch\n\
enabled=1\n\
autorefresh=1\n\
type=rpm-md\n\
' > /etc/yum.repos.d/elastic.repo \

## nodejs

 && curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - \

# Install additional software

 && yum -y install \
    wget \
    git \
    rsync \

## confd

 && curl --silent -Lo /usr/bin/confd https://github.com/kelseyhightower/confd/releases/download/v0.12.0-alpha3/confd-0.12.0-alpha3-linux-amd64 \
 && chmod +x /usr/bin/confd \

## sonar-scanner

  && curl --silent -Lo /sonar-scanner.zip https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-2.8.zip \
  && unzip /sonar-scanner.zip \
  && rm -f /sonar-scanner.zip /sonar-scanner-2.8/conf/sonar-scanner.properties \
  && ln -vs /sonar-scanner-2.8/bin/sonar-scanner /usr/bin/sonar-scanner \

# Install Toolchains

## standard devtools

 && yum -y groupinstall "Development Tools" \

## php

 && yum -y install \
    php70u-bcmath \
    php70u-cli \
    php70u-common \
    php70u-fpm \
    php70u-gd \
    php70u-imap \
    php70u-intl \
    php70u-json \
    php70u-ldap \
    php70u-mbstring \
    php70u-mcrypt \
    php70u-mysqlnd \
    php70u-odbc \
    php70u-pecl-amqp \
    php70u-pecl-apcu \
    php70u-pecl-redis \
    php70u-pecl-xdebug \
    php70u-pdo \
    php70u-process \
    php70u-recode \
    php70u-soap \
    php70u-tidy \
    php70u-twig \
    php70u-xml \
    php70u-xmlrpc \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin \
  && mv /usr/bin/composer.phar /usr/bin/composer \
  && chmod +x /usr/bin/composer \

## java

 && yum -y install java-1.8.0-openjdk-devel ant maven \

## nodejs

 && yum -y install nodejs-devel \
 && npm install -g grunt gulp bower yarn apidoc jspm phantomjs \

## ruby

 && yum -y install ruby ruby-devel libffi-devel \
 && gem install --no-document compass sass \

## python

 && yum -y install python35u python35u-devel python35u-pip \

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

 && yum -y install xorg-x11-server-Xvfb

# install configuration files

COPY confd                       /etc/confd
COPY nginx/nginx.conf            /etc/nginx/nginx.conf
COPY nginx/001-logformat.conf    /etc/nginx/conf.d/001-logformat.conf
COPY php/php.ini                 /etc/php.ini
COPY php/php-fpm.conf            /etc/php-fpm.conf
COPY php/www.conf                /etc/php-fpm.d/www.conf

EXPOSE 80 443 3306 6379 9200 9300 27017 27018 27019 28017

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
