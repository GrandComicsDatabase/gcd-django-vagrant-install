# Class: database_profile
#
#
class database_profile (
  $mysql_settings   = 'UNSET',
  $db_root_password = 'UNSET',
  $gcd_mysql_db     = 'UNSET',
) {

  include database_profile::params

  $real_db_root_password = $db_root_password ? {
    'UNSET' => $::database_profile::db_root_password,
    default => $db_root_password,
  }

  $real_mysql_settings = $mysql_settings ? {
    'UNSET' => $::database_profile::mysql_settings,
    default => $mysql_settings,
  }

  validate_string($real_db_root_password)
  validate_hash($real_mysql_settings)

  class { 'mysql':
    root_password => $real_db_root_password,
    options       => $real_mysql_settings,
  }

  $real_gcd_mysql_db = $gcd_mysql_db ? {
    'UNSET' => $::database_profile::gcd_mysql_db,
    default => $gcd_mysql_db,
  }

  validate_hash($real_gcd_mysql_db)

  mysql::grant { "${real_gcd_mysql_db}['db']":
    mysql_db         => $real_gcd_mysql_db['db'],
    mysql_user       => $real_gcd_mysql_db['user'],
    mysql_password   => $real_gcd_mysql_db['password'],
    mysql_create_db  => true,
    mysql_privileges => 'ALL',
  }
}