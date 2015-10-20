#!/usr/bin/env bash
#
# This builds the index for the gcd website
# Originally written by adia (https://github.com/adia)
# Updated by grosenbaum (http://github.com/grosenbaum)

. /opt/virtualenv/bin/activate
cd /vagrant/www
./manage.py rebuild_index --noinput