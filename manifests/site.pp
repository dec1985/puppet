class postgres {
  class { 'postgresql::server':
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    ip_mask_allow_all_users => '10.171.22.0/8',
    listen_addresses => '*',
    postgres_password => 'TPSrep0rt!',
  }
}

class application_base {
  # Note: for debian serious only
  exec { 'apt-update':
    command => '/usr/bin/apt-get update',
    onlyif => "/bin/bash -c 'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1|tail -1 )) )) <= 604800 ))'"
  }->
  package { [
             'libgeoip-dev',
             'libzmq-dev',
             'swig',
             'make',
             # already installed on ubuntu12.04 directly
             'python2.7',
             # Class['python'] will install python-dev, is it enough?
             'python2.7-dev',
             # conflict with Class['python']
             #'python-virtualenv'
             ]:
    ensure => present,
  }
}

class my_python {
  #vcsrepo { '/tmp/vcstest-git-clone':
  #  ensure   => present,
  #  provider => git,
  #  source   => 'git://github.com/bruce/rtex.git',
  #}
  class { 'python':
    pip => true,
    dev => true,
    virtualenv => true,
  }
  python::virtualenv { '/opt/env/redisenv':
    ensure => present,
    version => '2.7',
    #requirements => '',
    distribute => false,
  }
}

class base {
  include system
  include '::ntp'
  include git
  #class { ['my_fw::pre', 'my_fw::post']: }
}

import 'nodes/*.pp'

node 'puppet-slave1' {
  include base

  include postgres

  class { 'redis':
    version => '2.6.7',
  }

  include application_base
  include my_python
}

node default {
  include base
}

## firewall
resources { "firewall":
  purge => true
}
Firewall {
  before  => Class['my_fw::post'],
  require => Class['my_fw::pre'],
}

class my_fw::pre {
  Firewall {
    require => undef,
  }

  # Default firewall rules
  firewall { '000 drop all icmp':
    proto   => 'icmp',
    action  => 'drop',
  }->
  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }->
  firewall { '002 accept related established rules':
    proto   => 'all',
    ctstate => ['RELATED', 'ESTABLISHED'],
    action  => 'accept',
  }

  firewall { '003 allow ssh access':
    port   => [22],
    proto  => tcp,
    action => accept,
  }
}

class my_fw::post {
  firewall { '999 drop all':
    proto   => 'all',
    action  => 'drop',
    before  => undef,
  }
}
## end of firewall
