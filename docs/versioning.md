CI/CD will only push Docker images of the master-branch to the registy. Per image, you will find the following tags available. In the example below we use the PHP 7.0 image. The latest tagged stable version is 1.0.0.

```
docker1-registry.twobridges.io/nginx-php-fpm:7.0-latest
docker1-registry.twobridges.io/nginx-php-fpm:7.0-1.0.0
docker1-registry.twobridges.io/nginx-php-fpm:7.0-1
```

As you can see, there is a -latest, -1.0.0 (full version) and -1 (major version). **You are recommended to use the major version.** Newer versions of the same major will not include breaking changes.
