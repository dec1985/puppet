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

node 'puppet-master' {
  include base
  include puppetmaster
}

node default {
  include base
  include oak
}

