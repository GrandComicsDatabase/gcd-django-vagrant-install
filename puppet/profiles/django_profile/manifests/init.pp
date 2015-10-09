# Class: django_profile
#
# Main class to configure Django for GCD
#
# == Parameters
#
# Standard class parameters
# Define the class behaviour and customizations
#
# [*django_user*]
#   String defining default Django user
#   Default: 'vagrant'
# 
# [*vagrant_directory*]
#   String defining default vagrant directory
#   Default: '/vagrant'
# 
# [*gcd_vhost_directory*]
#   String defining default GCD vHost directory
#   Default: '/vagrant/www'
# 
# [*virtualenv_tools_directory*]
#   String defining virtualenv directory
#   Default: '/opt/virtualenv'
#  
# [*gcd_django_conf*]
#   String defining default path to Django config file for Upstart 
#   Default: '/etc/init/gcd-django.conf'
# 
# [*gcd_django_media_directories*]
#   Array defining default path to 'new_covers' and 'covers_by_id' directories
#   Default: [
#     '/vagrant/www/media/img/gcd/new_covers',
#     '/vagrant/www/media/img/gcd/covers_by_id',
#   ]
#
# === Authors
#
# Gilles Rosenbaum

class django_profile (
  $django_user                  = 'UNSET',
  $vagrant_directory            = 'UNSET',
  $gcd_vhost_directory          = 'UNSET',
  $virtualenv_tools_directory   = 'UNSET',
  $gcd_django_conf              = 'UNSET',
  $gcd_django_media_directories = 'UNSET',
) inherits django_profile::params {

  file { '/etc/environment':
    content => inline_template('DJANGO_SETTINGS_MODULE=settings')
  }

  $real_gcd_vhost_directory = $::django_profile::gcd_vhost_directory ? {
    'UNSET' => $django_profile::params::gcd_vhost_directory,
    default => $::django_profile::gcd_vhost_directory,
  }

  validate_absolute_path($real_gcd_vhost_directory)

  class { 'git':
    require => Exec['sysupdate'],
  }

  git::reposync { 'gcd-django':
    source_url      => 'https://github.com/GrandComicsDatabase/gcd-django.git',
    destination_dir => $real_gcd_vhost_directory,
    branch          => 'master',
  }

  $real_django_user = $::django_profile::django_user ? {
    'UNSET' => $django_profile::params::django_user,
    default => $::django_profile::django_user,
  }

  $real_virtualenv_tools_directory = $::django_profile::virtualenv_tools_directory ? {
    'UNSET' => $django_profile::params::virtualenv_tools_directory,
    default => $::django_profile::virtualenv_tools_directory,
  }

  $real_gcd_django_conf = $::django_profile::gcd_django_conf ? {
    'UNSET' => $django_profile::params::gcd_django_conf,
    default => $::django_profile::gcd_django_conf,
  }

  $real_gcd_django_media_directories = $::django_profile::gcd_django_media_directories ? {
    'UNSET' => $django_profile::params::gcd_django_media_directories,
    default => $::django_profile::gcd_django_media_directories,
  }

  $real_vagrant_directory = $::django_profile::vagrant_directory ? {
    'UNSET' => $django_profile::params::vagrant_directory,
    default => $::django_profile::vagrant_directory,
  }

  validate_string($real_django_user)
  validate_absolute_path($real_virtualenv_tools_directory)
  validate_absolute_path($real_gcd_django_conf)
  validate_array($real_gcd_django_media_directories)
  validate_string($real_vagrant_directory)

  class { 'python':
    version    => 'system',
    dev        => true,
    pip        => true,
    virtualenv => true,
  }

  python::virtualenv { $real_virtualenv_tools_directory:
    ensure     => present,
    version    => 'system',
    systempkgs => true,
    distribute => true,
    venv_dir   => $real_virtualenv_tools_directory,
    owner      => $real_django_user,
    group      => $real_django_user,
  }

  file { $real_gcd_django_media_directories:
    ensure  => directory,
    owner   => $real_django_user,
    group   => $real_django_user,
    mode    => '0755',
    require => Git::Reposync['gcd-django'],
  }

  file { "${real_gcd_vhost_directory}/settings_local.py":
    ensure  => file,
    owner   => $real_django_user,
    group   => $real_django_user,
    source  => "${real_vagrant_directory}/settings_local.py",
    path    => "${real_gcd_vhost_directory}/settings_local.py",
    require => Git::Reposync['gcd-django'],
  }

  file { $real_gcd_django_conf:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    source  => "${real_vagrant_directory}/gcd-django.conf",
    path    => $real_gcd_django_conf,
    require => File["${real_gcd_vhost_directory}/settings_local.py"],
  }

  service { 'gcd-django':
    ensure   => running,
    provider => 'upstart',
    require  => File[$real_gcd_django_conf],
  }
}