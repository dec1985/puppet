node 'fred-master.lan.happylatte.com' {
  include base

  class { 'munin::node': allow => hiera('munin_servers'), }
  include munin::master

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

  include apache

}
