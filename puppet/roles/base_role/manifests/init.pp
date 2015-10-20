# Class: base_role
#
# Main class to load the profiles for system configuration
#
# === Authors
#
# Gilles Rosenbaum

class base_role {
  class { 'base_profile': }
  class { 'cmdline_profile': }
  
  Class['base_profile']
  -> Class['cmdline_profile']
}