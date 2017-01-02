#!/usr/bin/env bash

./bin/healthcheck 10

# Prepare application
./bin/console cache:clear
#./bin/console doctrine:migration:migrate -n

php-fpm --allow-to-run-as-root
