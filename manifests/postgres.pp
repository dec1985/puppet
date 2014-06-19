class postgres {
  class { 'postgresql::server':
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    ip_mask_allow_all_users => '10.171.22.0/8',
    listen_addresses => '*',
    postgres_password => 'TPSrep0rt!',
  }
}
