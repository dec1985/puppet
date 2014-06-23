$yellow = hiera('yellow')

class virtual_env {
  file { ['/opt/env',
          '/opt/log',
          '/opt/redis-backup',
          ]:
    ensure => 'directory',
    owner => 'root',
    group => 'root',
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

define sso_env($env_name,
  $env,
  $etc,
  $owner = 'root',
  $group = 'root',
) {
  python::virtualenv { $env:
    ensure => present,
    version => '2.7',
    distribute => false,
    owner => "$owner",
    group => "$group",
  }->
  python::pip {"${env}_pip":
    pkgname => 'pip',
    ensure => '1.1',
    virtualenv => "$env",
    owner => $owner,
  }->
  file { "${env}/requirements":
    source => "puppet:///extra_files/${env_name}_requirements.txt",
    owner => $owner,
  }->
  python::requirements { "${env}_packages":
    virtualenv => "$env",
    requirements => "${env}/requirements",
    environment => 'PIP_PYPI_URL=https://highnoon:JstSmthngNwO_O@pypi.happylatte.com/private/',
  }
}

class sso_redis_env {
  $env_name = 'redisenv'
  $env = "/opt/env/$env_name"
  $etc = "$env/etc"

  sso_env { "$env_name":
    env_name => "$env_name",
    env => "$env",
    etc => "$etc",
  }

  file { ["$etc/sentineld.d",
          "$etc/twemproxyd.d",
          "$etc/sentineld_notification.d",
          "$etc/redis_farm.d"]:
    ensure => directory,
    require => Sso_env["$env_name"],
  }->
  config_file { ['etYellowUtils',
                 'yellowGevent',
                 'sentineld',
                 'twemproxyd',
                 'sentineld_notification',
                 'redis_farm',
                  ]:
    etc => $etc,
    yellow => $::yellow,
  }

  log_config_file { ['sentineld_logging_base',
                     'twemproxyd_logging_base',
                     'sentineld_notification_logging_base',
                     ]:
    etc => $etc,
    require => Sso_env["$env_name"],
  }
}

class sso_app_env {
  $env_name = 'ssoenv'
  $env = "/opt/env/$env_name"
  $etc = "$env/etc"

  # Note: happysso need Package['postgresql-server-dev-9.1']?
  #package { 'postgresql-server-dev-9.1':
  #  ensure => present,
  #}->
  sso_env { "$env_name":
    env_name => "$env_name",
    env => "$env",
    etc => "$etc",
  }
  file { "$etc/happysso.d/happysso.ini":
    content => template('happysso.ini.erb'),
    require => Sso_env["$env_name"],
  }
  file { 'yellowGevent.ini':
    path => "$etc/yellowGevent.d/yellowGevent.ini",
    content => template('yellowGevent.ini.erb'),
    require => Sso_env["$env_name"],
  }
  log_config_file { ['logging_base',]:
    etc => $etc,
    require => Sso_env["$env_name"],
  }
}

class sso_monitor_env {
  $env_name = 'monitorenv'
  $env = "/opt/env/$env_name"
  $etc = "$env/etc"

  sso_env { "$env_name":
    env_name => "$env_name",
    env => "$env",
    etc => "$etc",
  }->
  file { "$etc/etYellowUtils.d/etYellowUtils.ini":
    content => template('etYellowUtils.ini.erb'),
  }->
  file { '/etc/munin/plugins/sso':
    source => 'puppet:///extra_files/munin.py',
    mode => 0777,
  }~>
  exec { 'reload munin':
    command => "$env/bin/register_munin_plugins.py sso; service munin-node restart",
  }
}

class hns_env {
  $env_name = 'hnenv'
  $env = "/home/highnoon/$env_name"
  $etc = "$env/etc"

  User <| name == 'highnoon' |> {
  }->
  file { '/home/highnoon/log':
    ensure => directory,
    owner => 'highnoon',
    group => 'highnoon',
  }->
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
  sso_env { "$env_name":
    env_name => "$env_name",
    env => "$env",
    etc => "$etc",
    owner => 'highnoon',
    group => 'highnoon',
  }

  #file { '/etc/requirements.txt':
    #ensure => present,
    #source => 'puppet:///extra_files/requirements.txt',
  #}~>
  #exec { 'setup.sh':
  #  command => 'pip install -r /etc/requirements.txt > /tmp/setup.sh.log',
  #  user => 'highnoon',
  #  group => 'highnoon',
  #  path => ['/home/highnoon/hnenv/bin/', '/usr/local/bin', '/usr/bin', '/bin'],
  #  cwd => '/home/highnoon',
  #  environment => ['PIP_PYPI_URL=https://highnoon:JstSmthngNwO_O@pypi.happylatte.com/private/',
  #                  'ARCHFLAGS="-arch i386 -arch x86_64"'],
  #}->
  file { "$etc/hnYellow.d/hnYellow.ini":
    content => template('hnYellow.ini.erb'),
    require => Sso_env["$env_name"],
  }
  file { "$etc/etYellowUtils.d/etYellowUtils.ini":
    content => template('etYellowUtils.ini.erb'),
    require => Sso_env["$env_name"],
  }
}
