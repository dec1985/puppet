$yellow = hiera('yellow')

class highnoon::env {
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

define highnoon_env($env_name,
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
    group => $group,
  }->
  python::requirements { "${env}_packages":
    virtualenv => "$env",
    requirements => "${env}/requirements",
    environment => 'PIP_PYPI_URL=https://highnoon:JstSmthngNwO_O@pypi.happylatte.com/private/',
  }
}

class highnoon::sso_redis_env {
  $env_name = 'redisenv'
  $env = "/opt/env/$env_name"
  $etc = "$env/etc"

  highnoon_env { "$env_name":
    env_name => "$env_name",
    env => "$env",
    etc => "$etc",
  }

  file { ["$etc/sentineld.d",
          "$etc/twemproxyd.d",
          "$etc/sentineld_notification.d",
          "$etc/redis_farm.d"]:
    ensure => directory,
    require => Highnoon_env["$env_name"],
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
    require => Highnoon_env["$env_name"],
  }
}

class highnoon::sso_app_env {
  $env_name = 'ssoenv'
  $env = "/opt/env/$env_name"
  $etc = "$env/etc"

  # Note: happysso need Package['postgresql-server-dev-9.1']?
  #package { 'postgresql-server-dev-9.1':
  #  ensure => present,
  #}->
  highnoon_env { "$env_name":
    env_name => "$env_name",
    env => "$env",
    etc => "$etc",
  }
  file { "$etc/happysso.d/happysso.ini":
    content => template('happysso.ini.erb'),
    require => Highnoon_env["$env_name"],
  }
  file { 'yellowGevent.ini':
    path => "$etc/yellowGevent.d/yellowGevent.ini",
    content => template('yellowGevent.ini.erb'),
    require => Highnoon_env["$env_name"],
  }
  log_config_file { ['logging_base',]:
    etc => $etc,
    require => Highnoon_env["$env_name"],
  }
}

class highnoon::sso_monitor_env {
  $env_name = 'monitorenv'
  $env = "/opt/env/$env_name"
  $etc = "$env/etc"

  highnoon_env { "$env_name":
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

