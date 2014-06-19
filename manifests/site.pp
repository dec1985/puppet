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
    # TODO: don't accept group parameter, the default group is root.
    machine_user_password_triples => ['i.happylatte.com',hiera('gituser'),hiera('gitpasswd')],
  }->
  vcsrepo { '/home/highnoon/highnoon':
    ensure   => present,
    user => 'highnoon',
    provider => git,
    source   => 'https://i.happylatte.com/labs/git/highnoon.git',
  }->
  vcsrepo { '/home/highnoon/highnoon2data':
    ensure   => present,
    user => 'highnoon',
    provider => git,
    source   => 'https://code.happylatte.com/HighNoon2/highnoon2data',
  }->
  file { 'hnrc':
    ensure => present,
    owner => 'highnoon',
    group => 'highnoon',
    path => '/home/highnoon/.hnrc',
    content => "[sallyconf]\nserver_dir=/home/highnoon/highnoon/trunk/HighNoonServer\n",
  }
}

class python_env {
  file { '/opt/env':
    ensure => 'directory',
    owner => 'root',
    group => 'root',
    # so everyone can create sub folder.
    mode => 0777,
  }->
  class { 'python':
    pip => true,
    dev => true,
    virtualenv => true,
  }->


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

  # hns
  python::virtualenv { '/home/highnoon/hnenv':
    ensure => present,
    version => '2.7',
    systempkgs => false,
    distribute => true,
    owner => 'highnoon',
    group => 'highnoon',
    timeout => 0,
  }->
  python::pip { ['argparse==1.2.1',
                 'texttable==0.8.1',
                 'pytz==2012c',
                 'biplist==0.4',
                 'ujson==1.18',
                 'dnspython==1.10.0',
                 'redis==2.2.4',
                 'pycrypto==2.4.1',
                 'pyasn1==0.0.13',
                 'greenlet==0.4.0',
                 'pyOpenSSL==0.13',
                 'guppy==0.1.9',
                 'eventlet==0.9.16',
                 'configobj==4.7.2',
                 'Jinja2==2.1.1',
                 'mock==0.6.0',
                 'psycopg2==2.4.5',
                 'simplejson==2.0.9',
                 'pyzmq==2.2.0',
                 'zope.interface==4.0.1',
                 'Twisted==12.1.0',
                 'txZMQ==0.6.1',
                 'pyYAML==3.10',
                 'protobuf==2.4.1',
                 'pycountry==1.4',
                 'geoip2==0.5.1',
                 'pyfacebook-happylatte==1.0a2',
                 'Thrift-happylatte-py==0.8.0',
                 'sallyconf==1.1.0',
                 'hnProtocol==1.4.0.4',
                 'hnYellow==2.4.2',
                 'redisd==0.3.0',
                 'hnRedis==0.3.8',
                 'hnMonitor==1.0.4',
                 'hnDB==1.2.2',
                 'sallyutils==0.16.15',
                 'sallylog==0.3.3',
                 'hnHook==1.2.12',
                 'hndao==0.5.7',
                 'hnStrings==1.0.7',
                 'hnLadder==0.5.30.7',
                 'hnAPN==1.1.5',
                 'hnTel==0.3.11',
                 'hnJournal==0.4.5',
                 'hnMunin==0.5.10',
                 'hnStats==0.1.12',
                 'etYellowUtils==0.5.4-r2',
                 'notification==0.3.5',
                 'M2Crypto-happylatte==0.22r739.dev-r739',
                 'hnCompetition==0.2.29',
                 'hnItems==1.0.1',
                 'chatlib==0.3.18',
                 'happybroker==0.6.30',
                 'hnCasino==0.10.6',
                 'hnMission==0.0.45.32',
                 'statsproto==0.0.32']:
    virtualenv => '/home/highnoon/hnenv',
    environment => ['PIP_PYPI_URL=https://highnoon:JstSmthngNwO_O@pypi.happylatte.com/private/',
                    'ARCHFLAGS="-arch i386 -arch x86_64"'],
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
