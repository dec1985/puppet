resources { "firewall":
  purge => true
}
Firewall {
  before  => Class['my_fw::post'],
  require => Class['my_fw::pre'],
}

class my_fw::pre {
  Firewall {
    require => undef,
  }

  # Default firewall rules
  firewall { '000 drop all icmp':
    proto   => 'icmp',
    action  => 'drop',
  }->
  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }->
  firewall { '002 accept related established rules':
    proto   => 'all',
    ctstate => ['RELATED', 'ESTABLISHED'],
    action  => 'accept',
  }

  firewall { '003 allow ssh access':
    port   => [22],
    proto  => tcp,
    action => accept,
  }
}

class my_fw::post {
  firewall { '999 drop all':
    proto   => 'all',
    action  => 'drop',
    before  => undef,
  }
}
