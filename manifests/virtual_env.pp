class virtual_env {
  file { ['/opt/env',
          '/opt/log',
          '/opt/redis-backup',
          ]:
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

define config_file($etc, $yellow) {
  file { "$etc/$title.d/$title.ini":
    content => template("$title.ini.erb"),
  }
}
define log_config_file($etc) {
  file { "$etc/local_$title.cfg":
    content => template("log.cfg.erb"),
  }
}

class sso_redis_env {
  $env = '/opt/env/redisenv'
  $etc = "$env/etc"
  $yellow = '10.171.25.210'

  python::virtualenv { $env:
    ensure => present,
    version => '2.7',
    distribute => false,
  }->
  exec { 'downgrade pip to 1.1':
    command => '/opt/env/redisenv/bin/easy_install -U pip==1.1',
  }->
  python::pip { ['redis_shard',
                 'sallyutils',
                 'etYellowUtils==0.5.4-r2',
                 'yellowGevent==0.2.6a',
                 'redisd==0.6.0']:
    virtualenv => '/opt/env/redisenv',
    environment => 'PIP_PYPI_URL=https://highnoon:JstSmthngNwO_O@pypi.happylatte.com/private/',
  }->
  file { ["$etc/sentineld.d",
          "$etc/twemproxyd.d",
          "$etc/sentineld_notification.d",
          "$etc/redis_farm.d"]:
    ensure => directory,
  }->
  config_file { ['etYellowUtils',
                 'yellowGevent',
                 'sentineld',
                 'twemproxyd',
                 'sentineld_notification',
                 'redis_farm',
                  ]:
    etc => $etc,
    yellow => $yellow,
  }
  log_config_file { ['sentineld_logging_base',
                     'twemproxyd_logging_base',
                     'sentineld_notification_logging_base',
                     ]:
    etc => $etc,
  }
}

class sso_app_env {
  $etc = '/opt/env/ssoenv/etc'
  $yellow = '10.171.25.210'
  python::virtualenv { '/opt/env/ssoenv':
    ensure => present,
    version => '2.7',
    distribute => false,
  }->
  # Note: happysso need Package['postgresql-server-dev-9.1']
  package { 'postgresql-server-dev-9.1':
    ensure => present,
  }->
  python::pip { ['happysso==0.10.23',
                 'greenlet',
                 'configobj']:
    virtualenv => '/opt/env/ssoenv',
    environment => 'PIP_PYPI_URL=https://highnoon:JstSmthngNwO_O@pypi.happylatte.com/private/',
  }->
  file { "$etc/happysso.d/happysso.ini":
    content => template('happysso.ini.erb'),
  }->
  file { 'yellowGevent.ini':
    path => "$etc/yellowGevent.d/yellowGevent.ini",
    content => template('yellowGevent.ini.erb'),
  }->
  log_config_file { ['logging_base',]:
    etc => $etc
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
  $etc = '/home/highnoon/hnenv/etc'
  $yellow = $::ipaddress
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
  }->
  file { '/home/highnoon/hnenv/etc/hnYellow.d/hnYellow.ini':
    content => template('hnYellow.ini.erb'),
  }
  config_file { ['etYellowUtils',
                  ]:
    etc => $etc,
    yellow => $yellow,
  }
}
