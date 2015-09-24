node 'default' {

  class { 'base_role': }
  class { 'www_role': }
  class { 'data_role': }

  Class['base_role']
  -> Class['www_role']
  -> Class['data_role']
  
  package { 'puppet-lint':
    ensure   => '1.1.0',
    provider => 'gem',
  }
}
