node /hns\d+/ {
  include base
  class { 'highnoon::hns':
    yellow => $::ipaddress,
  }
}