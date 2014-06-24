class oak::motd {
  package { ['fortune-mod', 'fortune-zh', 'cowsay']:
    ensure => present,
  }
  file { "/etc/profile.d/login.sh":
    mode => 755,
    source => "puppet:///modules/oak/login.sh",
  }
}
