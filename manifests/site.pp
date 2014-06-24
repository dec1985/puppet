import 'base.pp'
import 'firewall.pp'

import 'puppetmaster.pp'

import 'nodes/*.pp'


node /sso-postgres\d+/ {
  include base
  class { 'highnoon::sso':
    yellow => hiera('yellow'),
  }
}

#node /sso-redis\d+/ {
#}
#node /sso-server\d+/ {
#  include sso
#}

node /hns\d+/ {
  include base
  class { 'highnoon::hns':
    yellow => $::ipaddress,
  }
}

node 'puppet-master', 'fred-master.lan.happylatte.com' {
  include base
  include puppetmaster
  include puppetdb
  include puppetdb::master::config

  include munin::master
  include apache

}

node default {
  include base
  class { 'oak::client':
  }
}

