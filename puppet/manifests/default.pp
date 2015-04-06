node 'default' {

  exec { 'sysupdate':
    command => '/usr/bin/apt-get update'
  }

  package { [
      'csstidy',
      'build-essential',
      'libmysqlclient-dev',
      'libjpeg-dev',
      'libicu-dev',
      'make',
      ]:
    ensure  => installed,
  }

  class { 'git': }

  git::reposync { 'gcd-django':
    source_url      => 'https://github.com/GrandComicsDatabase/gcd-django.git',
    destination_dir => '/vagrant/www/gcd-django',
  }

  git::reposync { 'python-graph':
    source_url      => 'https://github.com/pmatiello/python-graph',
    destination_dir => '/vagrant/tools/python-graph',
  }

  # exec { 'virtualenv-activate':
  #   command => 'source /vagrant/tools/virtualenv/bin/activate'
  # }

  # class { 'java7': }
  
  class { 'elasticsearch':
    ensure => present,
    java_install => false,
  }

  $gcd_django_media_directories = [ 
    "/vagrant/www/gcd-django/media", 
    "/vagrant/www/gcd-django/media/img", 
    "/vagrant/www/gcd-django/media/img/gcd", 
    "/vagrant/www/gcd-django/media/img/gcd/new_covers", 
    "/vagrant/www/gcd-django/media/img/gcd/covers_by_id",]

  exec { 'install-python-graph':
    command => '/usr/bin/pip install /vagrant/tools/python-graph/core'
  }
  
  # exec { 'media-directory':
  #   command => '/bin/mkdir -p /vagrant/www/media/img/gcd'
  # }

  file { $gcd_django_media_directories:
    ensure  => directory,
    owner   => vagrant,
    group   => vagrant,
    mode    => 0755,
  }

  file { '/vagrant/www/settings_local.py':
    ensure => file,
    owner  => vagrant,
    group  => vagrant,
    source => '/vagrant/settings_local.py',
    path   => '/vagrant/www/gcd-django/settings_local.py',
  }

  file { "/etc/environment":
    content => inline_template("DJANGO_SETTINGS_MODULE=settings")
  }

  class { 'ohmyzsh':
    require => Exec['sysupdate'],
  }
  
  ohmyzsh::install { ['root', 'vagrant']: }
  ohmyzsh::theme { ['root', 'vagrant']: theme => 'gianu' }
  ohmyzsh::plugins { ['root', 'vagrant']: plugins => 'git github python pip django' }

  class { 'mysql': }

  mysql::grant { "gcd-database":
      mysql_user       => root,
      mysql_password   => gcd,
      mysql_db         => gcd,
      mysql_create_db  => true,
      mysql_privileges => 'ALL',
  }

  class { 'python' :
    version    => 'system',
    pip        => true,
    dev        => true,
    virtualenv => true,
    gunicorn   => false,
  }
  
  python::virtualenv { '/vagrant/tools/virtualenv' :
    ensure       => present,
    version      => 'system',
    requirements => '/vagrant/www/gcd-django/requirements.txt',
    systempkgs   => true,
    distribute   => true,
    owner        => 'vagrant',
    group        => 'vagrant',
    # require      => Exec['virtualenv-activate'],
  }
  
  python::pip { ['requests', 'pip'] :
    pkgname       => 'requests',
    virtualenv    => '/vagrant/tools/virtualenv',
    owner         => 'vagrant',
    install_args  => ['-U'],
  }
  
   python::pip { 'python-graph-core' :
     pkgname       => 'python-graph-core',
     # ensure      => 'xxxx',
     virtualenv    => '/vagrant/tools/virtualenv',
     owner         => 'vagrant',
     install_args  => ['-U -r requirements.txt --allow-all-external --allow-unverified rbtools --allow-unverified'],
     require       => Exec['install-python-graph'],
   }

    # ./manage.py syncdb --migrate --noinput
    # ./manage.py loaddata users
    # python <../initialize_countstats.py
    # ./manage.py rebuild_index --noinput

    #
    # exec { 'initialize-gcd-django':
    #   command => '/vagrant/www/gcd-django/manage.py syncdb --migrate --noinput'
    # }
    #

  # mysql-server
  # git
  # python-pip
  # python-virtualenv
  # python-dev


  # csstidy
  # build-essential \
  # libmysqlclient-dev
  # libjpeg-dev
  # libicu-dev \
  # openjdk-7-jre-headless
  # elasticsearch

}