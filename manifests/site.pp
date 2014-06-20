import 'base.pp'
import 'firewall.pp'

import 'package.pp'
import 'code.pp'
import 'virtual_env.pp'
import 'postgres.pp'

import 'nodes/*.pp'

node 'puppet-slave1' {
#  include base

  include postgres

  class { 'redis':
    version => '2.6.7',
  }

  include application_base
  include code
  include python_env
}

# Dependencies
Class['sso_package'] -> Class['sso_redis_env']

class sso {
  include base
  include sso_package
  include virtual_env
  include sso_redis_env
  include sso_app_env
  # TODO: add it later
  #include sso_monitor_env
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
}

