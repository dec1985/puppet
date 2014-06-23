class highnoon::sso_package {
  include highnoon::virtual
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
             'postgresql-server-dev-9.1',
             ]:
    ensure => present,
  }
}
