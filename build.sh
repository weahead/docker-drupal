#!/bin/sh
set -e

docker build --pull -t weahead/drupal:8.8.5 .
