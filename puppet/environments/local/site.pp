node 'default' {

  exec { 'sysupdate':
    command => '/usr/bin/apt-get update'
  }

  $gcd_vhost_directory          = "/vagrant/www"
  $tools_directory              = "/vagrant/tools"
  $script_tools_directory       = "/vagrant/tools/scripts"
  $virtualenv_tools_directory   = "/vagrant/tools/virtualenv"
  $is_new_search_activated      = undef
  $gcd_django_media_directories = [ "${gcd_vhost_directory}/media/img/gcd/new_covers", 
                                    "${gcd_vhost_directory}/media/img/gcd/covers_by_id"]

  file { "/etc/environment":
    content => inline_template("DJANGO_SETTINGS_MODULE=settings")
  }

  package { [
      'csstidy',
      'build-essential',
      'libmysqlclient-dev',
      'libjpeg-dev',
      'libicu-dev',
      'make'
      ]:
    ensure  => installed,
    require => Exec['sysupdate'],
  }

  class { 'git': }

  git::reposync { 'gcd-django':
    source_url      => 'https://github.com/GrandComicsDatabase/gcd-django.git',
    destination_dir => "${gcd_vhost_directory}",
    branch          => 'master',
  }
  
  class { 'ohmyzsh':
    require => Exec['sysupdate'],
  }
  
  ohmyzsh::install { ['root', 'vagrant']: }
  ohmyzsh::theme   { ['root', 'vagrant']: theme   => 'gianu' }
  ohmyzsh::plugins { ['root', 'vagrant']: plugins => 'git github python pip django' }


  class { 'mysql': }

  mysql::grant { "%{hiera('local_gcd_mysql_db')":
      mysql_db         => hiera('local_gcd_mysql_db'),
      mysql_user       => hiera('local_gcd_mysql_user'),
      mysql_password   => hiera('local_gcd_mysql_password'),
      mysql_create_db  => true,
      mysql_privileges => 'ALL',
      require          => Class['mysql']
  }

  # class { '::mysql::server':
  #   root_password           => hiera('mysql_root_password'),
  #   # remove_default_accounts => true,
  #   # default_engine          => hiera('mysql_default_engine')
  # }
 
  # include '::mysql::server'

  # mysql::db { 'gcd':
  #   ensure  => present,
  #   dbname   => hiera('local_gcd_mysql_db'),
  #   user     => hiera('local_gcd_mysql_user'),
  #   password => hiera('local_gcd_mysql_password'),
  #   host     => 'localhost',
  #   grant    => 'ALL',
  #   require => Class['mysql::server']
  # }

  # mysql_grant { "root@localhost/%{hiera('local_gcd_mysql_db')}.*":
  #   ensure     => 'present',
  #   options    => ['GRANT'],
  #   privileges => ['ALL'],
  #   table      => '*.*',
  #   user       => 'root@localhost',
  # }


  class { 'python':
    version    => 'system',
    pip        => true,
    dev        => true,
    virtualenv => true,
    gunicorn   => false,
  }
  
  python::virtualenv { "${virtualenv_tools_directory}":
    ensure       => present,
    version      => 'system',
    requirements => "${gcd_vhost_directory}/requirements.txt",
    systempkgs   => true,
    distribute   => true,
    venv_dir     => "${virtualenv_tools_directory}",
    owner        => 'vagrant',
    group        => 'vagrant',
    require      => Git::Reposync['gcd-django'],
  }

  python::pip { ['requests', 'pip', 'python-graph-core']:
    virtualenv    => "${virtualenv_tools_directory}",
    owner         => 'vagrant',
    install_args  => ['-U'],
  }

  file { $gcd_django_media_directories:
    ensure  => directory,
    owner   => 'vagrant',
    group   => 'vagrant',
    mode    => 0755,
  }

  file { "${gcd_vhost_directory}/settings_local.py":
    ensure => file,
    owner  => 'vagrant',
    group  => 'vagrant',
    source => '/vagrant/settings_local.py',
    path   => "${gcd_vhost_directory}/settings_local.py",
  }

  Git::Reposync['gcd-django'] -> File[$gcd_django_media_directories] -> File["${gcd_vhost_directory}/settings_local.py"]

  file { "/etc/init/gcd-django.conf":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    source => '/vagrant/gcd-django.conf',
    path   => "/etc/init/gcd-django.conf",
  }
  ->
  service { "gcd-django":
      ensure => running,
      provider => "upstart",
  }
 
    Class['mysql'] -> Class['python'] -> File[$gcd_django_media_directories]

}