# Class: cmdline_profile::params
#
# This class defines default parameters used by the main module class cmdline_profile
#
# == Variables
#
# Refer to cmdline_profile, ohmyzsh classes for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be inherited by other classes.
#
# === Authors
#
# Gilles Rosenbaum

class cmdline_profile::params {
  $gitconfig = {
    'color' => { 'ui'     => true },
    'core'  => { 'editor' => 'vim' }
  }
  $ohmyzsh = {
    'theme'   => 'gianu',
    'plugins' => 'git github python pip django',
    'custom'  =>  '',
  }
  $default_user = 'vagrant'
  $vimrc = "
    :syntax on\n
    :set expandtab\n
    :set tabstop=4\n
    :set shiftwidth=4\n
    :set smarttab"
}