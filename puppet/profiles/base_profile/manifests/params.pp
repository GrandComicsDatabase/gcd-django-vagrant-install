# Class base_profile::params
#
#
class base_profile::params {
  $base_packages  = [
    'csstidy','build-essential','libmysqlclient-dev',
    'libjpeg-dev','libicu-dev',
    'tig','make','vim','zip'
  ]
  $ntp_servers = [
    '0.pool.ntp.org iburst',
    '1.pool.ntp.org iburst',
    '2.pool.ntp.org iburst',
    '3.pool.ntp.org iburst',
  ]
  $timezone       = 'UTC'
  $default_locale = 'en_US.UTF-8'
  $locale         = [
    'en_US.UTF-8 UTF-8',
    'de_DE.UTF-8 UTF-8',
    'fr_FR.UTF-8 UTF-8',
  ]
}