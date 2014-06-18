class base {
  include system
  include '::ntp'
}

import 'nodes/*.pp'

node default {
  include base
}

