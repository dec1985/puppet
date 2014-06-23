import 'base.pp'
import 'firewall.pp'

import 'package.pp'
import 'code.pp'
import 'virtual_env.pp'
import 'postgres.pp'

import 'nodes/*.pp'


class sso {
  include base
  include sso_package
  include sso_postgres
  include virtual_env
  include sso_redis_env
  include sso_app_env
  include sso_monitor_env

  Class['sso_package'] -> Class['sso_postgres'] -> Class['virtual_env'] -> Class['sso_redis_env', 'sso_app_env', 'sso_monitor_env']
}

class hns {
  include base
  include hns_package
  include hns_code
  include hns_postgres
  include virtual_env
  include hns_env

  # postgres depends on code bacause it need to run some sql command which in code base
  Class['hns_package'] -> Class['hns_code'] -> Class['hns_postgres'] -> Class['virtual_env'] -> Class['hns_env']
}


node /sso-postgres\d+/ {
  include sso
  include postgres
  include sso_postgres
}

node /sso-redis\d+/ {
  include sso
}

node /sso-server\d+/ {
  include sso
}

node /hns\d+/ {
  Class['hns_package'] -> Class['hns_code'] -> Class['hns_env']

  include base
  include hns_package
  include hns_code
  include virtual_env
  include hns_env
  include postgres
  include hns_postgres
}

node default {
  include base
  include hns
}

