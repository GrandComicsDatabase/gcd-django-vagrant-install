#!/usr/bin/env bash
#
# This bootstraps mysql for the gcd website
# Originally written by adia (https://github.com/adia)
# Updated by grosenbaum (http://github.com/grosenbaum)

. /opt/virtualenv/bin/activate
cd /vagrant/www
./manage.py syncdb --migrate --noinput
./manage.py loaddata users
python <../initialize_countstats.py