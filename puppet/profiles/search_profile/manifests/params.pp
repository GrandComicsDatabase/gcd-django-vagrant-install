# Class: search_profile::params
#
#
class search_profile::params {
  $elasticsearch_node_repo_url    = 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.5.deb'
  $elasticsearch_node_instance    = 'node-01'
  $elasticsearch_with_marvel      = true
  $elasticsearch_marvel_instances = 'node-01'
  $elasticsearch_with_java        = true
  $elasticsearch_cluster_name     = 'UNSET'
  $elasticsearch_config           = []
}