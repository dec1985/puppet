class highnoon::sso_postgres {
  include postgres
  postgresql::server::role { 'happylatte':
    createrole => true,
    superuser => true,
  }
  postgresql::server::db { 'happyUsers':
    user => 'happylatte',
    password => '',
  }->
  # TODO: fix the depndency, this two files both notify Exec.
  file { '/etc/database.sql':
    ensure => present,
    source => 'puppet:///extra_files/database.sql',
  }->
  file { '/etc/update.sql':
    ensure => present,
    source => 'puppet:///extra_files/update.sql',
  }~>
  exec { '/etc/init_sso_db':
    command => 'psql -U happylatte -f /etc/database.sql happyUsers; psql -U happylatte -f /etc/update.sql happyUsers; touch /etc/init_sso_db;',
    creates => '/etc/init_sso_db',
    path => ['/usr/bin'],
  }
}
