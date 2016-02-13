#!/bin/sh

set -e
apt-get update
apt-get install gnupg apt-utils nginx

if test -d /var/www/html
then
  mkdir /var/www/html/repo
  chmod a+wx /var/www/html/repo
fi
