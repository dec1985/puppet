class base {
  include system
  include '::ntp'
  # TODO: for debian os only.
  exec { 'apt-update':
    command => '/usr/bin/apt-get update',
    onlyif => "/bin/bash -c 'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1|tail -1 )) )) <= 604800 ))'"
  }->
  package { ['htop', 'dstat', 'iotop', 'tree', 'git', 'munin']:
    ensure => present,
  }
}
