class sso_package {
  package { [# already installed on ubuntu12.04 directly
             'python2.7',
             # Class['python'] will install python-dev, is it enough?
             'python2.7-dev',
             # conflict with Class['python']
             #'python-virtualenv'
             'libgeoip-dev',
             'libzmq-dev',
             'swig',
             'make',
             ]:
    ensure => present,
  }
}

class hns_package {
  package { [# Class['python'] will install python-dev
             #'python-dev',
             # conflict with Class['python']
             #'python-virtualenv'
             'libzmq-dev',
             'swig',
             'make',
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
              # below 2 are for stats
              'protobuf-compiler',
              'python-protobuf',

             # TODO: move it to Class['postgres']
             # below is for hns - db
             #'postgresql-9.1',
             'postgresql-9.1-postgis',
             #'postgresql-server-dev-9.1',
             # below is for hns
             ]:
    ensure => present,
  }
}
