# bhaa-wordpress-plugin

[![Build Status](https://github.com/emeraldjava/bhaa-wordpress-plugin/workflows/build/badge.svg)](https://github.com/emeraldjava/bhaa-wordpress-plugin)

A wordpress plugin for the BHAA website.

## Composer

    composer install --no-dev
    composer dump-autoload --classmap-authoritative

## Docker

Setup a DB and wordpress instance in a docker container. wp-cli can be installed locally or within a docker container.

- Link this plugin via softlink to wordpress

    sudo yum install docker-compose

- https://stackoverflow.com/questions/54650759/how-to-access-wordpress-docker-site-on-another-computer-in-network
- https://computingforgeeks.com/how-to-install-php-7-4-on-centos-7/