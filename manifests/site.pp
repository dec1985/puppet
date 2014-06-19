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

             # below is for hns - db
             #'postgresql-9.1',
             'postgresql-9.1-postgis',
             #'postgresql-server-dev-9.1',
             # below is for hns
              'libpq-dev',
              'libgeos-dev',
              'libyaml-dev',
              'libboost-dev',
              'libevent-dev',
              'autoconf',
              'automake',
              'libtool',
              'ruby-dev',
              'bison',
              'flex',
              'colordiff',
              # confilct with puppetlibs-gcc module
              #'build-essential',
              'pkg-config',
              'protobuf-compiler',
              'python-protobuf',
             ]:
    ensure => present,
  }
}

class code {
  user { 'highnoon':
    ensure => 'present',
    home => '/home/highnoon',
    managehome => true,
    shell => '/bin/bash',
  }->
  netrc::foruser{"highnoon":
    user => 'highnoon',
    machine_user_password_triples => ['i.happylatte.com',hiera('gituser'),hiera('gitpasswd')],
  }->
  vcsrepo { '/home/highnoon/highnoon':
    ensure   => present,
    user => 'highnoon',
    provider => git,
    source   => 'https://i.happylatte.com/labs/git/highnoon.git',
  }
}

class python_env {
  class { 'python':
    pip => true,
    dev => true,
    virtualenv => true,
  }


  # reids server
  python::virtualenv { '/opt/env/redisenv':
    ensure => present,
    version => '2.7',
    distribute => false,
  }->
  python::pip { ['redis_shard']:
    virtualenv => '/opt/env/redisenv',
    environment => 'PIP_PYPI_URL=https://highnoon:JstSmthngNwO_O@pypi.happylatte.com/private/',
  }

  # sso server
  python::virtualenv { '/opt/env/ssoenv':
    ensure => present,
    version => '2.7',
    distribute => false,
  }->
  # Note: happysso need Package['postgresql-server-dev-9.1']
  package { 'postgresql-server-dev-9.1':
    ensure => present,
  }->
  python::pip { ['happysso', 'greenlet', 'configobj']:
    virtualenv => '/opt/env/ssoenv',
    environment => 'PIP_PYPI_URL=https://highnoon:JstSmthngNwO_O@pypi.happylatte.com/private/',
  }

  # hns - for monitor
  python::virtualenv { '/opt/env/hnsenv':
    ensure => present,
    version => '2.7',
    distribute => false,
  }->
  python::pip { ['hnMonitor', 'sallylog']:
    virtualenv => '/opt/env/hnsenv',
    environment => 'PIP_PYPI_URL=https://highnoon:JstSmthngNwO_O@pypi.happylatte.com/private/',
  }
}

class base {
  include system
  include '::ntp'
  include git
  #class { ['my_fw::pre', 'my_fw::post']: }
  package { ['htop', 'dstat', 'iotop', 'tree']:
    ensure => present,
  }
}

import 'nodes/*.pp'

node 'puppet-slave1' {
  include base

  include postgres

  class { 'redis':
    version => '2.6.7',
  }

  include application_base
  include code
  include python_env
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
