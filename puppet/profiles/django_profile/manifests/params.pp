# Class: django_profile::params
#
#
class django_profile::params {
  $django_user                  = 'vagrant'
  $vagrant_directory            = '/vagrant'
  $gcd_vhost_directory          = '/vagrant/www'
  $virtualenv_tools_directory   = '/opt/virtualenv'
  $gcd_django_conf              = '/etc/init/gcd-django.conf'
  $gcd_django_media_directories = [
    '/vagrant/www/media/img/gcd/new_covers',
    '/vagrant/www/media/img/gcd/covers_by_id',
  ]
}