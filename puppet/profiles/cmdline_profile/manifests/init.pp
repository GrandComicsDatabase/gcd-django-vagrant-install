# Class: cmdline_profile
#
# Main class to configure command line tools for the system
#
# == Parameters
#
# Standard class parameters
# Define the class behaviour and customizations
#
# [*default_user*]
#   String defining default user of the system
#   Default: 'vagrant'
# 
# [*gitconfig*]
#   Hash defining default configuration of git
#   Default: {
#     'color' => { 'ui'     => true },
#     'core'  => { 'editor' => 'vim' }
#     },
#   }
# 
# [*ohmyzsh*]
#   Hash defining default configutation of oh-my-zsh
#   Default: {
#     'theme'   => 'gianu',
#     'plugins' => 'git github python pip django',
#     'custom'  =>  '',
#   }
#
# [*vimrc*]
#   String defining default configuration of vim
#   Default: "
#     :syntax on\n
#     :set expandtab\n
#     :set tabstop=4\n
#     :set shiftwidth=4\n
#     :set smarttab"
#
# === Authors
#
# Gilles Rosenbaum

class cmdline_profile (
  $default_user = 'UNSET',
  $gitconfig    = 'UNSET',
  $ohmyzsh      = 'UNSET',
  $vimrc        = 'UNSET',
) inherits cmdline_profile::params {

  $real_default_user = $::cmdline_profile::default_user ? {
    'UNSET' => $cmdline_profile::params::default_user,
    default => $::cmdline_profile::default_user,
  }

  $real_gitconfig = $::cmdline_profile::gitconfig ? {
    'UNSET' => $cmdline_profile::params::gitconfig,
    default => $::cmdline_profile::gitconfig,
  }

  validate_hash($real_gitconfig)
  validate_string($real_default_user)

  file { "/home/${real_default_user}/.gitconfig":
    ensure    => present,
    content   => template('cmdline_profile/gitconfig.erb'),
    mode      => '0644',
    owner     => $real_default_user,
    show_diff => false,
    require   => Package['git'],
  }

  $real_ohmyzsh = $::cmdline_profile::ohmyzsh ? {
    'UNSET' => $cmdline_profile::params::ohmyzsh,
    default => $::cmdline_profile::ohmyzsh,
  }

  validate_hash($real_ohmyzsh)

  class { 'ohmyzsh':
    require => Exec['sysupdate'],
  }
  
  ohmyzsh::install { ['root', $real_default_user]: }

  ohmyzsh::theme   { ['root', $real_default_user]:
    theme   => $real_ohmyzsh['theme'],
  }

  ohmyzsh::plugins { ['root', $real_default_user]:
    plugins => $real_ohmyzsh['plugin'],
  }

  file { "/home/${real_default_user}/.oh-my-zsh/custom/local.zsh":
    ensure    => present,
    content   => $real_ohmyzsh['custom'],
    mode      => '0644',
    owner     => $real_default_user,
    show_diff => false,
    require   => Ohmyzsh::Install['root', $real_default_user],
  }

  $real_vimrc = $::cmdline_profile::vimrc ? {
    'UNSET' => $cmdline_profile::params::vimrc,
    default => $::cmdline_profile::vimrc,
  }

  validate_string($real_vimrc)

  file { "/home/${default_user}/.vimrc":
    ensure    => present,
    content   => template('cmdline_profile/vimrc.erb'),
    mode      => '0644',
    owner     => $real_default_user,
    show_diff => false,
    require   => Package['vim'],
  }
}