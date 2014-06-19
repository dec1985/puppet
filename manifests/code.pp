class code {
  user { 'highnoon':
    ensure => 'present',
    home => '/home/highnoon',
    managehome => true,
    shell => '/bin/bash',
  }->
  netrc::foruser{"highnoon":
    user => 'highnoon',
    # TODO: don't accept group parameter, the default group is root.
    machine_user_password_triples => ['i.happylatte.com',hiera('gituser'),hiera('gitpasswd')],
  }->
  vcsrepo { '/home/highnoon/highnoon':
    ensure   => present,
    user => 'highnoon',
    provider => git,
    source   => 'https://i.happylatte.com/labs/git/highnoon.git',
  }->
  vcsrepo { '/home/highnoon/highnoon2data':
    ensure   => present,
    user => 'highnoon',
    provider => git,
    source   => 'https://code.happylatte.com/HighNoon2/highnoon2data',
  }->
  file { 'hnrc':
    ensure => present,
    owner => 'highnoon',
    group => 'highnoon',
    path => '/home/highnoon/.hnrc',
    content => "[sallyconf]\nserver_dir=/home/highnoon/highnoon/trunk/HighNoonServer\n",
  }
}
