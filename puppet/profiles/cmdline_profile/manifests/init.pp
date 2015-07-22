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
#     'core'  => { 'editor' => 'vim' },
#     'user'  => {
#       'name'  => 'You Github Name',
#       'email' => 'You Github eMail',
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

class cmdline_profile (
  $default_user = 'UNSET',
  $gitconfig    = 'UNSET',
  $ohmyzsh      = 'UNSET',
  $vimrc        = 'UNSET',
) {

  include cmdline_profile::params

  $real_default_user = $default_user ? {
    'UNSET' => $::cmdline_profile::default_user,
    default => $default_user,
  }

  $real_gitconfig = $gitconfig ? {
    'UNSET' => $::cmdline_profile::gitconfig,
    default => $gitconfig,
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

  $real_ohmyzsh = $ohmyzsh ? {
    'UNSET' => $::cmdline_profile::ohmyzsh,
    default => $ohmyzsh,
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

  $real_vimrc = $vimrc ? {
    'UNSET' => $::cmdline_profile::vimrc,
    default => $vimrc,
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