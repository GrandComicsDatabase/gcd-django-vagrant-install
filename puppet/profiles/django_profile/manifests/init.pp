# Class: django_profile
#
#
class django_profile (
  $django_user                  = 'UNSET',
  $vagrant_directory            = 'UNSET',
  $gcd_vhost_directory          = 'UNSET',
  $virtualenv_tools_directory   = 'UNSET',
  $gcd_django_conf              = 'UNSET',
  $gcd_django_media_directories = 'UNSET',
) {

  include django_profile::params

  file { '/etc/environment':
    content => inline_template('DJANGO_SETTINGS_MODULE=settings')
  }

  $real_gcd_vhost_directory = $gcd_vhost_directory ? {
    'UNSET' => $::django_profile::gcd_vhost_directory,
    default => $gcd_vhost_directory,
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

  $real_django_user = $django_user ? {
    'UNSET' => $::django_profile::django_user,
    default => $django_user,
  }

  $real_virtualenv_tools_directory = $virtualenv_tools_directory ? {
    'UNSET' => $::django_profile::virtualenv_tools_directory,
    default => $virtualenv_tools_directory,
  }

  $real_gcd_django_conf = $gcd_django_conf ? {
    'UNSET' => $::django_profile::gcd_django_conf,
    default => $gcd_django_conf,
  }

  $real_gcd_django_media_directories = $gcd_django_media_directories ? {
    'UNSET' => $::django_profile::gcd_django_media_directories,
    default => $gcd_django_media_directories,
  }

  $real_vagrant_directory = $vagrant_directory ? {
    'UNSET' => $::django_profile::vagrant_directory,
    default => $vagrant_directory,
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