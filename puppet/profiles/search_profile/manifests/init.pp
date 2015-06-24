# Class: search_profile
#
#
class search_profile (
  $elasticsearch_node_repo_url    = 'UNSET',
  $elasticsearch_node_instance    = 'UNSET',
  $elasticsearch_with_marvel      = 'UNSET',
  $elasticsearch_marvel_instances = 'UNSET',
  $elasticsearch_with_java        = 'UNSET',
  $elasticsearch_config           = 'UNSET',
  $elasticsearch_cluster_name     = 'UNSET',
) {

  include search_profile::params

  $real_elasticsearch_config = $elasticsearch_config ? {
    'UNSET' => $::search_profile::elasticsearch_config,
    default => $elasticsearch_config,
  }

  $real_elasticsearch_cluster_name = $elasticsearch_cluster_name ? {
    'UNSET' => $::search_profile::elasticsearch_cluster_name,
    default => $elasticsearch_cluster_name,
  }

  $default_config = merge($real_elasticsearch_config, {
    'cluster.name' => $real_elasticsearch_cluster_name,
  })

  validate_hash($default_config)

  $real_elasticsearch_node_repo_url = $elasticsearch_node_repo_url ? {
    'UNSET' => $::search_profile::elasticsearch_node_repo_url,
    default => $elasticsearch_node_repo_url,
  }
  
  validate_string($real_elasticsearch_node_repo_url)

  class { 'elasticsearch':
    package_url  => $real_elasticsearch_node_repo_url,
    java_install => true,
    config       => $default_config,
  }

  $real_elasticsearch_node_instance = $elasticsearch_node_instance ? {
    'UNSET' => $::search_profile::elasticsearch_node_instance,
    default => $elasticsearch_node_instance,
  }

  validate_string($real_elasticsearch_node_instance)

  elasticsearch::instance { $real_elasticsearch_node_instance: }

  $real_elasticsearch_with_marvel = $elasticsearch_with_marvel ? {
    'UNSET' => $::search_profile::elasticsearch_with_marvel,
    default => $elasticsearch_with_marvel,
  }

  $real_elasticsearch_marvel_instances = $elasticsearch_marvel_instances ? {
    'UNSET' => $::search_profile::elasticsearch_marvel_instances,
    default => $elasticsearch_marvel_instances,
  }

  validate_bool($real_elasticsearch_with_marvel)
  validate_string($real_elasticsearch_marvel_instances)

  if $real_elasticsearch_with_marvel {
    elasticsearch::plugin { 'elasticsearch/marvel/latest':
      module_dir => 'marvel',
      instances  => $real_elasticsearch_marvel_instances,
    }
  }
}