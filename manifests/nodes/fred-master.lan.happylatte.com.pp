class puppetmaster {
  package { ['vim-puppet']:
    ensure => present,
    notify => Exec['enable-vim-puppet'],
  }

  exec { 'enable-vim-puppet':
    command     => '/usr/bin/vim-addons -w install puppet',
    refreshonly => true,
    require     => Package['vim-puppet'],
  }
}

node 'fred-master.lan.happylatte.com' {
  include base

  class { '::oak::puppet_agent':
    puppet_server      => 'fred-master.lan.happylatte.com',
    puppet_server_port => '7400',
  }

  class { '::oak::puppet_master':
    autosign           => true,
    puppet_server_port => '7400',
  }

  include puppetdb
  include puppetdb::master::config

  include munin::master
  include apache

}
