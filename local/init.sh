#!/bin/sh
make
docker-compose up -d
docker-compose exec drupal with-contenv bash -lc 'COMPOSER_MEMORY_LIMIT=-1 composer install'
make install
make update-settings-php update-config-from-environment solr-cores run-islandora-migrations
docker-compose exec drupal drush cr -y
