# Class: data_role
#
# Main class to load the profiles for database configuration
#
# === Authors
#
# Gilles Rosenbaum

class data_role {
  class { 'database_profile': }
  class { 'search_profile': }
  
  Class['database_profile']
  -> Class['search_profile']
}