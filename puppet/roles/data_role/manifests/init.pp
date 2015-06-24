# Class: data_role
#
#
class data_role {
  class { 'database_profile': }
  class { 'search_profile': }
  
  Class['database_profile']
  -> Class['search_profile']
}