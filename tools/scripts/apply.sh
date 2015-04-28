#!/usr/bin/env bash
#
# This activates the provisionning of the local vm
# Originally written by grosenbaum (http://github.com/grosenbaum)

puppet apply /vagrant/puppet/environments/local/site.pp --modulepath=/vagrant/puppet/modules --environment=/vagrant/puppet/environments --hiera_config=/vagrant/puppet/hiera.yaml --confdir=/vagrant/puppet