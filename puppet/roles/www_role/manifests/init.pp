# Class: www_role
#
# Main class to load the profile for Django configuration
#
# === Authors
#
# Gilles Rosenbaum

class www_role {
  class { 'django_profile': }
}