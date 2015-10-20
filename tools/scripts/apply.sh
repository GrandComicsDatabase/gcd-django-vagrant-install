#!/usr/bin/env bash
#
# This activates the provisionning of the local vm
# Originally written by grosenbaum (http://github.com/grosenbaum)

LOG_FILE=/var/log/puppet/apply_puppet.$(date "+%Y-%m-%d.%H-%M-%S").log
ERR_LOG_FILE=/var/log/puppet/apply_puppet.$(date "+%Y-%m-%d.%H-%M-%S").err.log

puppet apply /vagrant/puppet/environments/local/site.pp \
  --modulepath=/vagrant/puppet/modules:/vagrant/puppet/profiles:/vagrant/puppet/roles \
  --environment=local \
  --confdir=/vagrant/puppet \
  --verbose --show_diff  \
  --logdest console > >(tee $LOG_FILE) 2> >(tee $ERR_LOG_FILE >&2)