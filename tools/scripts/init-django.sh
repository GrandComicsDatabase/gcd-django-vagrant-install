#!/usr/bin/env bash
#
# This bootstraps django for the gcd website
# Originally written by adia (https://github.com/adia)
# Updated by grosenbaum (http://github.com/grosenbaum)

. /vagrant/tools/virtualenv/bin/activate
cd /vagrant/www
pip install -U -r requirements.txt --allow-all-external --allow-unverified rbtools --allow-unverified python-graph-core