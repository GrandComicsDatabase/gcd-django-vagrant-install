# Class: base_role
#
#
class base_role {
  class { 'base_profile': }
  class { 'cmdline_profile': }
  
  Class['base_profile']
  -> Class['cmdline_profile']
}