class oak::puppet_client {
  package { 'puppet':
    ensure => 'present',
  }
  file { '/etc/puppet/puppet.conf':
    require => Package['puppet'],
    source => 'puppet:///modules/oak/puppet.conf',
  }
}

