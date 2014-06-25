class oak::puppet_master ($autosign = false, $puppet_server_port = 8140) {
  package { 'puppetmaster': ensure => 'present', }

  package { ['vim-puppet']:
    ensure => present,
    notify => Exec['enable-vim-puppet'],
  }

  exec { 'enable-vim-puppet':
    command     => '/usr/bin/vim-addons -w install puppet',
    refreshonly => true,
    require     => Package['vim-puppet'],
  }

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

