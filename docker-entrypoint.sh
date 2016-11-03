#!/bin/bash

set -eufo pipefail

function start_xvfb {
  export XVFB_RESOLUTION="${XVFB_RESOLUTION:-1024x768x16}"
  export DISPLAY=:1.0
  Xvfb :1 -screen 0 ${XVFB_RESOLUTION} &
  sleep 1
}

function start_elasticsearch {
  export ES_HOME=/usr/share/elasticsearch
  export CONF_DIR=/etc/elasticsearch
  export DATA_DIR=/var/lib/elasticsearch
  export LOG_DIR=/var/log/elasticsearch
  export PID_DIR=/var/run/elasticsearch

  cd ${ES_HOME}
  sudo -u elasticsearch /usr/share/elasticsearch/bin/elasticsearch \
    -p ${PID_DIR}/elasticsearch.pid \
    -Edefault.path.logs=${LOG_DIR} \
    -Edefault.path.data=${DATA_DIR} \
    -Edefault.path.conf=${CONF_DIR} &

  cd -
  sleep 10
}

function start_mongodb {
  sudo -u mongod /usr/bin/mongod -f /etc/mongod.conf &
  sleep 1
}

function start_mariadb {
  echo "bind-address=0.0.0.0" >> /etc/my.cnf
  /usr/bin/mysql_install_db --datadir="/var/lib/mysql" --user=mysql
  /usr/bin/mysqld_safe --datadir="/var/lib/mysql" --socket="/var/lib/mysql/mysql.sock" --user=mysql &
  sleep 1
}

function start_redis {
  sudo -u redis /usr/bin/redis-server &
  sleep 1
}

function start_php_fpm {
  /usr/sbin/php-fpm --nodaemonize &
  sleep 1
}

function start_nginx {
  # Set configuration
  export NGX_DOCUMENT_ROOT="${NGX_DOCUMENT_ROOT:-/var/www/html/web}"
  export NGX_PHP_FRONT_CONTROLLER="${NGX_PHP_FRONT_CONTROLLER:-app.php}"
  export NGX_PHP_LOCATION="${NGX_PHP_LOCATION:-^/${NGX_PHP_FRONT_CONTROLLER}(/|$)}"

  confd -onetime -backend env --log-level info
  /usr/sbin/nginx -g "daemon off;" -c /etc/nginx/nginx.conf &

  sleep 1
}

function start_services {
  for service in ${START_SERVICES}; do
    echo " ---> Starting service '${service}'"
    case ${service} in
      nginx)
        start_nginx
        ;;
      php-fpm)
        start_php_fpm
        ;;
      redis)
        start_redis
        ;;
      mariadb)
        start_mariadb
        ;;
      mongodb)
        start_mongodb
        ;;
      elasticsearch)
        start_elasticsearch
        ;;
      xvfb)
        start_xvfb
        ;;
      *)
        echo >&2 " ---> Skipping unknown service '${service}'"
        ;;
    esac
  done
}

# Start services

if [ ! -z ${START_SERVICES+x} ]; then
  start_services
fi

# Execute command

if [ -z ${@+x} ]; then
  echo " ---> Sleeping"
  sleep infinity
else
  echo " ---> Running your command"
  "$@"
fi
