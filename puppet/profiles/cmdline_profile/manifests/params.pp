# Class: cmdline_profile::params
#
#
class cmdline_profile::params {
  $gitconfig = {
    'color' => { 'ui'     => true },
    'core'  => { 'editor' => 'vim' },
    'user'  => {
      'name'  => 'You Github Name',
      'email' => 'You Github eMail',
      },
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