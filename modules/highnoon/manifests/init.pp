# == Class: highnoon
#
# Full description of class highnoon here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { highnoon:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
# TODO: dependence on python module.
class highnoon {
}

class highnoon::sso {
  include highnoon::sso_package
  include highnoon::sso_postgres
  include highnoon::env
  include highnoon::sso_redis_env
  include highnoon::sso_app_env
  include highnoon::sso_monitor_env

  Class['highnoon::sso_package'] -> Class['highnoon::sso_postgres'] -> Class['highnoon::env'] -> Class['highnoon::sso_redis_env', 'highnoon::sso_app_env', 'highnoon::sso_monitor_env']
}

class highnoon::hns {
  include highnoon::hns_package
  include highnoon::hns_code
  include highnoon::hns_postgres
  include highnoon::env
  include highnoon::hns_env

  # postgres depends on code bacause it need to run some sql command which in code base
  Class['highnoon::hns_package'] -> Class['highnoon::hns_code'] -> Class['highnoon::hns_postgres'] -> Class['highnoon::env'] -> Class['highnoon::hns_env']
}
