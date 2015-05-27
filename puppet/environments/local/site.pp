node 'default' {

  $vagrant_directory            = '/vagrant'
  $gcd_vhost_directory          = "${vagrant_directory}/www"
  $tools_directory              = "${vagrant_directory}/tools"
  $script_tools_directory       = "${tools_directory}/scripts"
  $virtualenv_tools_directory   = '/usr/local/virtualenv'

  $default_user                 = 'vagrant'

  exec { 'sysupdate':
    command => '/usr/bin/apt-get update'
  }

  package { [ 'csstidy', 'build-essential', 'libmysqlclient-dev', 'libjpeg-dev',
              'libicu-dev', 'tig', 'make', 'vim', 'zip']:
    ensure  => installed,
    require => Exec['sysupdate'],
  }

  file { '/etc/environment':
    content => inline_template('DJANGO_SETTINGS_MODULE=settings')
  }

  if hiera('vimrc') {
    file { "/home/${default_user}/.vimrc":
      ensure => present,
      content => hiera('vimrc'),
      mode => '0644',
      owner => $default_user,
      show_diff => false,
      require => Package['vim'],
    }
  }

  if hiera('lc_all') {
    class { 'locales':
      lc_all => hiera('lc_all'),
    }
  }

  class { 'git': }

  git::reposync { 'gcd-django':
    source_url      => 'https://github.com/GrandComicsDatabase/gcd-django.git',
    destination_dir => "${gcd_vhost_directory}",
    branch          => 'master',
  }

  $gitconfig_user       = hiera('user')
  $gitconfig_user_name  = $gitconfig_user['name']
  $gitconfig_user_email = $gitconfig_user['email']
  
  $gitconfig_template   = "
  [user]
    name = ${gitconfig_user_name}
    email = ${gitconfig_user_email}
  "

  file { '/home/vagrant/.gitconfig':
    ensure    => present,
    content   => $gitconfig_template,
    mode      => '0644',
    owner     => $default_user,
    show_diff => false,
    require   => Package['git'],
  }
  
  $ohmyzsh_theme = hiera('ohmyzsh')

  class { 'ohmyzsh': 
    require => Exec['sysupdate'],
  }
  
  ohmyzsh::install { [ 'root', "${default_user}"]: }
  ohmyzsh::theme   { [ 'root', "${default_user}"]: 
    theme   => $ohmyzsh_theme,
  }
  ohmyzsh::plugins { [ 'root', "${default_user}"]: 
    plugins => 'git github python pip django',
  }

  if hiera('custom') {
    file { [ "/home/${default_user}/.oh-my-zsh",
             "/home/${default_user}/.oh-my-zsh/custom",
           ]:
      ensure => directory,
      mode => '0755',
      owner => $default_user,
      require => Ohmyzsh::Install["${default_user}"],
    }
    file { "/home/${default_user}/.oh-my-zsh/custom/local.zsh":
      ensure => present,
      content => hiera('custom'),
      mode => '0644',
      owner => $default_user,
      show_diff => false,
    }
  }

  class { 'mysql': }

  mysql::grant { "%{hiera('local_gcd_mysql_db')}":
    mysql_db         => hiera('local_gcd_mysql_db'),
    mysql_user       => hiera('local_gcd_mysql_user'),
    mysql_password   => hiera('local_gcd_mysql_password'),
    mysql_create_db  => true,
    mysql_privileges => 'ALL',
    require          => Class['mysql']
  }

  class { 'python':
    version    => 'system',
    dev        => true,
    pip        => true,
    virtualenv => true,
  }
  
  python::virtualenv { "${virtualenv_tools_directory}":
    ensure     => present,
    version    => 'system',
    systempkgs => true,
    distribute => true,
    venv_dir   => "${virtualenv_tools_directory}",
    owner      => $default_user,
    group      => $default_user,
  }

  $gcd_django_media_directories = [ 
    "${gcd_vhost_directory}/media/img/gcd/new_covers", 
    "${gcd_vhost_directory}/media/img/gcd/covers_by_id"
  ]

  file { $gcd_django_media_directories:
    ensure  => directory,
    owner   => $default_user,
    group   => $default_user,
    mode    => '0755',
    require => Git::Reposync['gcd-django'],
  }

  file { "${gcd_vhost_directory}/settings_local.py":
    ensure  => file,
    owner   => $default_user,
    group   => $default_user,
    source  => "${vagrant_directory}/settings_local.py",
    path    => "${gcd_vhost_directory}/settings_local.py",
    require => Git::Reposync['gcd-django'],
  }

  $gcd_django_conf = '/etc/init/gcd-django.conf'
  file { $gcd_django_conf:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    source  => "${vagrant_directory}/gcd-django.conf",
    path    => $gcd_django_conf,
    require => File["${gcd_vhost_directory}/settings_local.py"],
  }

  service { 'gcd-django':
    ensure   => running,
    provider => 'upstart',
    require  => File[$gcd_django_conf],
  }

  $elasticsearch_version     = '1.4.5'
  $elasticsearch_package_url = "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${elasticsearch_version}.deb"

  class { 'elasticsearch':
    package_url  => $elasticsearch_package_url,
    java_install => true,
  }

  elasticsearch::instance { 'node-01': }
}
