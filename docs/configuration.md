You can change the behaviour of this image by setting one or more environment variables.

## Confd

Environment variable | Default value | Description
--- | --- | ---
CONFD_LOG_LEVEL | `info` | Defines the log level of confd, which is used to generate the nginx vhost configuration file from a template.

## Nginx

Environment variable | Default value | Description
--- | --- | ---
NGX_DOCUMENT_ROOT | /var/www/html/web | Defines the document root.
NGX_PROXY | 0 | Toggles whether Nginx should derive the real ip-address from the X-Real-IP header. Lookups are **not** done recursive. Only a single substition will take place. Only use this if your container is running behind a reverse proxy that you trust.
NGX_PHP_FRONT_CONTROLLER | app.php | Defines the front controller of your application. All incoming requests that do not match a file on the filesystem will be rewriten as (per default) app.php/$request. The front controller should reside in the document root.
NGX_PHP_LOCATION | ^/${NGX_PHP_FRONT_CONTROLLER}(/\|$) | Defines a regular expression that will determine what requests will be passed on to php-fpm. By default this will be ^/app.php(/\|$) . If you set `NGX_PHP_FRONT_CONTROLLER`, then that value will be used instead of `app.php`. If you want to be able to execute all `.php` files, set this to ^/.*\\.php(/\|$).
NGX_TLS | 0 | This will be set to 1, which will enable TLS inside nginx, but only if the files `/tls/tls.key` and `/tls/tls.crt` are found inside the container. Use a volume mount, Kubernetes configmap/secret or something similar.

## Example -- Zend Expressive
The below environment variables can be set to configure the container to work with a Zend Expressive application.

```
ENV NGX_DOCUMENT_ROOT=/var/www/html/public
ENV NGX_PHP_FRONT_CONTROLLER=index.php
```

## Example -- Symfony debugging

`ENV NGX_PHP_LOCATION=^/(app|app_dev|config)\.php(/|$)`

## Extending functionality

You can have a look at the [nginx vhost template](../files/confd/templates/www.conf.tmpl). You can override this with your own template, if you'd like. You can include new NGX_* environment variables to use inside your template and pass them to your container.

For example, inside a Dockerfile in your project, do this:

```
COPY nginx/www.conf.tmpl /etc/confd/templates/www.conf.tmpl
ENV NGX_MY_COOL_FEATURE=1
```
