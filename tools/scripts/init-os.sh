#!/usr/bin/env bash
#
# This bootstraps Puppet on Ubuntu 12.04 LTS.
# Originally written by mitchellh from hashicorp (https://github.com/hashicorp)
# Updated by grosenbaum (http://github.com/grosenbaum)

set -e
_DEBUG="off"

function DEBUG()
{
 [ "$_DEBUG" == "on" ] && "$@"
}

# Debug activation
# DEBUG set -x

# Load up the release information
. /etc/lsb-release

REPO_DEB_URL="http://apt.puppetlabs.com/puppetlabs-release-${DISTRIB_CODENAME}.deb"

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

if dpkg-query -W puppet && apt-cache policy | grep --quiet apt.puppetlabs.com; then
  echo "Puppet is already installed."
else
  # Do the initial apt-get update
  echo "Initial apt-get update"
  apt-get update > /dev/null
  # Purge packages
  dpkg --list | grep "^rc" | cut -d " " -f 3 | xargs sudo dpkg --purge

  # Install wget if we have to (some older Ubuntu versions)
  echo "Installing wget"
  DEBIAN_FRONTEND=noninteractive apt-get install -y wget > /dev/null

  # Install the PuppetLabs repo
  echo "Configuring PuppetLabs repo"
  repo_deb_path=$(mktemp)
  wget --output-document="${repo_deb_path}" "${REPO_DEB_URL}" 2> /dev/null
  dpkg -i "${repo_deb_path}" > /dev/null
  apt-get update >/dev/null

  # Install Puppet
  echo "Installing Puppet"
  DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install puppet > /dev/null
  echo "Puppet installed!"
fi

if gem list | grep --quiet deep_merge; then
  echo "Gems are already installed."
else
  # Install RubyGems for the provider
  echo "Installing RubyGems"
  if [ "$DISTRIB_CODENAME" != "trusty" ]; then
    DEBIAN_FRONTEND=noninteractive apt-get install -y rubygems > /dev/null
  fi
  gem install --no-ri --no-rdoc rubygems-update deep_merge
  update_rubygems > /dev/null
  echo "Gems installed!"
fi

if dpkg -l git | grep --quiet 'no description available'; then
  # Install Git to be able to initialize submodules
  echo "Installing git"
  DEBIAN_FRONTEND=noninteractive apt-get install -y git > /dev/null
  echo "Git installed!"
else
  echo "Git is already installed."
fi

cd /vagrant
if git config --list | grep --quiet submodule; then
  echo "Git submodules are already installed"
else
  echo "Installing git submodules"
  git submodule update --init
  echo "Git submodules installed!"  
fi

# Debug desactivation
# DEBUG set +x