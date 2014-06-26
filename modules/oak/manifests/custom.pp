class oak::custom ($home = '/root') {
  file { "$home/.gitconfig": source => 'puppet:///extra_files/gitconfig', }

  file { "$home/.vimrc": source => 'puppet:///extra_files/vimrc', }

  file { "$home/.screenrc": source => 'puppet:///extra_files/screenrc', }

  file { "$home/.bash_profile": source => 'puppet:///extra_files/bash_profile', }
}
