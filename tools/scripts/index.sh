#!/usr/bin/env bash
#
# This bootstraps mysql for the gcd website
# Originally written by adia (https://github.com/adia)
# Updated by grosenbaum (http://github.com/grosenbaum)

. /usr/local/virtualenv/bin/activate
cd /vagrant/www
./manage.py rebuild_index --noinput