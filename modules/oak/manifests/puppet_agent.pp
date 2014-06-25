class oak::puppet_agent ($puppet_server, $puppet_server_port = 8140) {
  file { '/etc/puppet/puppet.conf': content => template('oak/puppet.conf.erb'), }
}

