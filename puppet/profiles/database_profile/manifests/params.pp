# Class: database_profile::params
#
#
class database_profile::params {
  $mysql_settings = {
    'mysqld' => {
      'innodb_file_per_table'          => '',
      'collation-server'               => 'utf8_unicode_ci',
      'init-connect'                   => '"SET NAMES utf8"',
      'character-set-server'           => 'utf8',
      'tmp_table_size'                 => '128M',
      'max_heap_table_size'            => '128M',
      'max_allowed_packet'             => '64M',
      'table_open_cache'               => '450',
      'wait_timeout'                   => '600',
      'innodb_log_file_size'           => '512M',
      'innodb_log_files_in_group'      => '2',
      'innodb_log_buffer_size'         => '32M',
      'innodb_flush_log_at_trx_commit' => '2',
      'innodb_lock_wait_timeout'       => '50',
      'innodb_flush_method'            => 'O_DIRECT',
      'innodb_open_files'              => '65535',
      'innodb_max_dirty_pages_pct'     => '40',
      'bind-addr'                      => '0.0.0.0',
      'skip-name-resolve'              => '',
    },
    'client' => {
      'default-character-set' => 'utf8'
    }
  }
  $db_root_password = 'root'
  $gcd_mysql_db = {
    'db'       => 'gcd',
    'user'     => 'root',
    'password' => 'gcd',
  }
}