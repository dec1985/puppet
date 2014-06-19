class base {
  include system
  include '::ntp'
  include git
  #class { ['my_fw::pre', 'my_fw::post']: }
  package { ['htop', 'dstat', 'iotop', 'tree']:
    ensure => present,
  }
}
