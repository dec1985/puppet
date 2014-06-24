class custom($home = '/root') {
  file { "$home/.gitconfig":
    source => 'puppet:///extra_files/gitconfig',
  }
  file {"$home/.vimrc":
    source => 'puppet:///extra_files/vimrc',
  }
  file {"$home/.screenrc":
    source => 'puppet:///extra_files/screenrc',
  }
  file { "$home/.bash_profile":
    source => 'puppet:///extra_files/bash_profile',
  }
}

class base {
  include system
  include custom
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
