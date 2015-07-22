# = Class: base_profile
#
# Main base class to configure the system
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*base_packages*]
#   Array defining default system packages to install
#   Default: [
#    'csstidy','build-essential','libmysqlclient-dev',
#    'libjpeg-dev','libicu-dev',
#    'tig','make','vim','zip'
#   ]
#
# [*ntp_servers*]
#   Array defining default system packages to install
#   Default: [
#     '0.pool.ntp.org iburst',
#     '1.pool.ntp.org iburst',
#     '2.pool.ntp.org iburst',
#     '3.pool.ntp.org iburst',
#   ]
#
# [*timezone*]
#   String defining default system timezone
#   Default: 'UTC'
#
# [*default_locale*]
#   String defining default local among array of locales
#   Default: 'en_US.UTF-8'
#
# [*locales*]
#   Array defining locales to install
#   Default: [
#     'en_US.UTF-8 UTF-8',
#     'de_DE.UTF-8 UTF-8',
#     'fr_FR.UTF-8 UTF-8',
#   ]

class base_profile (
  $base_packages  = 'UNSET',
  $ntp_servers    = 'UNSET',
  $timezone       = 'UNSET',
  $default_locale = 'UNSET',
  $locales        = 'UNSET',
) {
  
  include base_profile::params

  exec { 'sysupdate':
    command => '/usr/bin/apt-get update',
  }

  $real_base_packages = $base_packages ? {
    'UNSET' => $::base_profile::base_packages,
    default => $base_packages,
  }

  validate_array($real_base_packages)
  ensure_packages($real_base_packages)

  $real_ntp_servers = $ntp_servers ? {
    'UNSET' => $::base_profile::ntp_servers,
    default => $ntp_servers,
  }

  validate_array($real_ntp_servers)
  class { 'ntp':
      servers => $ntp_servers,
  }

  $real_default_locale = $default_locale ? {
    'UNSET' => $::base_profile::default_locale,
    default => $default_locale,
  }

  $real_locales = $locales ? {
    'UNSET' => $::base_profile::locales,
    default => $locales,
  }

  validate_string($real_default_locale)
  validate_array($real_locales)
  
  class { 'locales':
      default_locale => $real_default_locale,
      locales        => $real_locales,
  }

  $real_timezone = $timezone ? {
    'UNSET' => $::base_profile::timezone,
    default => $timezone,
  }

  validate_string($real_default_locale)

  class { 'timezone':
      timezone => $real_timezone,
  }
}