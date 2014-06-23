import 'base.pp'
import 'firewall.pp'

import 'nodes/*.pp'


node /sso-postgres\d+/ {
  include base
  include highnoon::sso
}

#node /sso-redis\d+/ {
#}
#node /sso-server\d+/ {
#  include sso
#}

node /hns\d+/ {
  include base
  include highnoon::hns
}

node default {
  include base
}

