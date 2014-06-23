class postgres {
  package { [#'postgresql-9.1',
             #'postgresql-server-dev-9.1',
             'postgresql-9.1-postgis']:
    ensure => present,
  }
  class { 'postgresql::server':
    listen_addresses => '*',
    postgres_password => 'TPSrep0rt!',
  }

  postgresql::server::pg_hba_rule { '10.0.0.0/8':
    type => 'host',
    database => 'all',
    user => 'all',
    auth_method => 'trust',
    address => '10.0.0.0/8',
  }
}
