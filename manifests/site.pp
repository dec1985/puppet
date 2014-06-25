import 'base.pp'
import 'firewall.pp'

import 'nodes/*.pp'

node default {
  include base

  class { 'oak::client': }
}

