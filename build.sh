#!/bin/sh
set -e

docker build --pull -t weahead/drupal:8.5.14 .
