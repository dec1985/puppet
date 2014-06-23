@package { ['libzmq-dev',
            'swig',
            'make']:
  ensure => present,
}

class sso_package {
  realize( Package['libzmq-dev'] )
  realize( Package['swig'] )
  realize( Package['make'] )
  package { [# already installed on ubuntu12.04 directly
             'python2.7',
             # Class['python'] will install python-dev, is it enough?
             'python2.7-dev',
             # conflict with Class['python']
             #'python-virtualenv'
             'libgeoip-dev',
             ]:
    ensure => present,
  }
}

class hns_package {
  realize( Package['libzmq-dev'] )
  realize( Package['swig'] )
  realize( Package['make'] )
  package { [# Class['python'] will install python-dev
             #'python-dev',
             # conflict with Class['python']
             #'python-virtualenv'
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
             ]:
    ensure => present,
  }
}
