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
