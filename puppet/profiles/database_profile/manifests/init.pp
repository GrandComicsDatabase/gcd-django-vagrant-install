# Class: database_profile
#
# Main class to configure MySQL for GCD
#
# == Parameters
#
# Standard class parameters
# Define the class behaviour and customizations
#
# [*mysql_settings*]
#   Hash defining default parameters for MySQL
#   Default: {
#     'mysqld' => {
#       'innodb_file_per_table'          => '',
#       'collation-server'               => 'utf8_unicode_ci',
#       'init-connect'                   => '"SET NAMES utf8"',
#       'character-set-server'           => 'utf8',
#       'tmp_table_size'                 => '128M',
#       'max_heap_table_size'            => '128M',
#       'max_allowed_packet'             => '64M',
#       'table_open_cache'               => '450',
#       'wait_timeout'                   => '600',
#       'innodb_log_file_size'           => '512M',
#       'innodb_log_files_in_group'      => '2',
#       'innodb_log_buffer_size'         => '32M',
#       'innodb_flush_log_at_trx_commit' => '2',
#       'innodb_lock_wait_timeout'       => '50',
#       'innodb_flush_method'            => 'O_DIRECT',
#       'innodb_open_files'              => '65535',
#       'innodb_max_dirty_pages_pct'     => '40',
#       'bind-addr'                      => '0.0.0.0',
#       'skip-name-resolve'              => '',
#     },
#     'client' => {
#       'default-character-set' => 'utf8'
#     }
#   }
# 
# [*db_root_password*]
#   String defining default root password for MySQL
#   Default: 'root'
# 
# [*gcd_mysql_db*]
#   Hash defining default account information for the GCD database
#   Default: {
#     'db'       => 'gcd',
#     'user'     => 'root',
#     'password' => 'gcd',
#   }

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