class oak::puppet_master ($autosign = false, $puppet_server_port = 8140) {
  package { 'puppetmaster': ensure => 'present', }

  file { '/etc/default/puppetmaster':
    require => Package['puppetmaster'],
    content => template('oak/puppetmaster.erb'),
    before  => File['/etc/puppet/autosign.conf'],
  }

  if $autosign {
    file { '/etc/puppet/autosign.conf': content => "*\n", }
  } else {
    file { '/etc/puppet/autosign.conf': ensure => absent, }
  }

}

