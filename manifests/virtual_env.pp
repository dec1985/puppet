class virtual_env {
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
  }
}

class sso_redis_env {
  python::virtualenv { '/opt/env/redisenv':
    ensure => present,
    version => '2.7',
    distribute => false,
  }->
  python::pip { ['redis_shard']:
    virtualenv => '/opt/env/redisenv',
    environment => 'PIP_PYPI_URL=https://highnoon:JstSmthngNwO_O@pypi.happylatte.com/private/',
  }
}

class sso_app_env {
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
}

class sso_monitor_env {
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

class hns_env {
  python::virtualenv { '/home/highnoon/hnenv':
    ensure => present,
    version => '2.7',
    distribute => false,
    owner => 'highnoon',
    group => 'highnoon',
  }->
  file { '/home/highnoon/log':
    ensure => directory,
    owner => 'highnoon',
    group => 'highnoon',
  }
  # TODO: remove this after you get the /root/.init files.
  # install requirements has a bug which need to write something to /root/.init/
  file { ['/root/']:
    ensure => directory,
    mode => 0755,
  }->
  file { ['/root/.init']:
    ensure => directory,
    mode => 0777,
  }->
  file { '/etc/requirements.txt':
    ensure => present,
    source => 'puppet:///extra_files/requirements.txt',
  }~>
  exec { 'setup.sh':
    command => 'pip install -r /etc/requirements.txt > /tmp/setup.sh.log',
    user => 'highnoon',
    group => 'highnoon',
    path => ['/home/highnoon/hnenv/bin/', '/usr/local/bin', '/usr/bin', '/bin'],
    cwd => '/home/highnoon',
    environment => ['PIP_PYPI_URL=https://highnoon:JstSmthngNwO_O@pypi.happylatte.com/private/',
                    'ARCHFLAGS="-arch i386 -arch x86_64"'],
  }
}
