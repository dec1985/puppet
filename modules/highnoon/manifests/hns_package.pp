class highnoon::hns_package {
  include highnoon::virtual
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
