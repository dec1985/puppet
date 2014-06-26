node 'fred-slave.lan.happylatte.com' {
  include base

  class { 'munin::node': allow => hiera('munin_servers'), }

  class { '::oak::puppet_agent':
    puppet_server      => 'fred-master.lan.happylatte.com',
    puppet_server_port => '7400',
  }

}
