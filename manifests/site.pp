import 'base.pp'
import 'firewall.pp'

import 'application_base.pp'
import 'code.pp'
import 'python_env.pp'

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

node default {
  include base
  include postgres

  class { 'redis':
    version => '2.6.7',
  }

  include application_base
  include code
  include python_env
}

