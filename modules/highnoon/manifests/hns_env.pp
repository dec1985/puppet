class highnoon::hns_env {
  $env_name = 'hnenv'
  $env = "/home/highnoon/$env_name"
  $etc = "$env/etc"

  include highnoon::virtual
  realize( User['highnoon'] )
  file { '/home/highnoon/log':
    ensure => directory,
    owner => 'highnoon',
    group => 'highnoon',
    require => User['highnoon'],
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
  highnoon_env { "$env_name":
    env_name => "$env_name",
    env => "$env",
    etc => "$etc",
    owner => 'highnoon',
    group => 'highnoon',
  }

  file { "$etc/hnYellow.d/hnYellow.ini":
    content => template('hnYellow.ini.erb'),
    require => Highnoon_env["$env_name"],
    owner => 'highnoon',
  }
  file { "$etc/etYellowUtils.d/etYellowUtils.ini":
    content => template('etYellowUtils.ini.erb'),
    require => Highnoon_env["$env_name"],
    owner => 'highnoon',
  }
}
