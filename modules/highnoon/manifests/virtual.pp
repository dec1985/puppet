class highnoon::virtual {
  @user { 'highnoon':
    ensure => 'present',
    home => '/home/highnoon',
    managehome => true,
    shell => '/bin/bash',
  }

  @package { ['libzmq-dev',
              'swig',
              'make']:
    ensure => present,
  }

}
