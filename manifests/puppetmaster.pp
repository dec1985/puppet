class puppetmaster {
  package { ['vim-puppet']:
    ensure => present,
    notify => Exec['enable-vim-puppet'],
  }
  exec { 'enable-vim-puppet':
    command => '/usr/bin/vim-addons -w install puppet',
    refreshonly => true,
    require => Package['vim-puppet'],
  }
}
