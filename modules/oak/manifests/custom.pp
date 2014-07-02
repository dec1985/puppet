class oak::custom ($home = '/root') {
  file { "$home/.gitconfig": source => 'puppet:///modules/oak/gitconfig', }

  file { "$home/.vimrc": source => 'puppet:///modules/oak/vimrc', }

  file { "$home/.screenrc": source => 'puppet:///modules/oak/screenrc', }

  file { "$home/.bash_profile": source => 'puppet:///modules/oak/bash_profile', }
}
