# node /sso-redis\d+/ {
#}
# node /sso-server\d+/ {
#  include sso
#}


node /sso-postgres\d+/ {
  include base

  class { 'highnoon::sso': yellow => hiera('yellow'), }

}
