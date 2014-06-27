class base {
  #  include system
  include ntp
  include motd

  if $::osfamily == 'Debian' {
    include apt
  }
  include git

  package { ['htop', 'dstat', 'iotop', 'tree']: ensure => present, }
  # fred's module
  include oak

}
