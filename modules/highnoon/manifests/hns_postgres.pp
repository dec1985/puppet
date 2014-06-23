class highnoon::hns_postgres {
  include postgres
  postgresql::server::role { 'highnoon':
    createrole => true,
    superuser => true,
  }->
  postgresql::server::db { 'highnoon':
    user => 'highnoon',
    password => '',
  }->
  postgresql::server::db { 'mission':
    user => 'highnoon',
    password => '',
  }->
  # TODO: there is a bug here, must make sure the code had already setupped before.
  # TODO: change the ';' in command to '&&'.
  exec { '/etc/init_hns_db':
    command => 'psql -d highnoon -U highnoon -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql; psql -d highnoon -U highnoon -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql; psql -d highnoon -U highnoon -f /usr/share/postgresql/9.1/contrib/postgis_comments.sql; psql -d highnoon -U highnoon -f /home/highnoon/highnoon/trunk/HighNoonServer/highnoon/models/schema.sql; psql -d highnoon -U highnoon -f /home/highnoon/highnoon/trunk/HighNoonServer/highnoon/models/geoip.sql; psql -d highnoon -U highnoon -f /home/highnoon/highnoon/trunk/HighNoonServer/highnoon/models/l10n.sql; psql -d highnoon -U highnoon -f /home/highnoon/highnoon/trunk/HighNoonServer/highnoon/models/comp_telegram_daily_l10n.sql; psql -d highnoon -U highnoon -f /home/highnoon/highnoon/trunk/HighNoonServer/highnoon/models/comp_telegram_weekly_l10n.sql; psql -d highnoon -U highnoon -f /home/highnoon/highnoon/trunk/HighNoonServer/highnoon/models/mission_l10.sql; psql -d highnoon -U highnoon -f /home/highnoon/highnoon/trunk/HighNoonServer/highnoon/models/item_init.sql; psql -d mission -U highnoon -f /home/highnoon/hnenv/lib/python2.7/site-packages/hnMission/conf/schema.sql; psql -d mission -U highnoon -f /home/highnoon/hnenv/lib/python2.7/site-packages/hnMission/conf/update.sql; touch /etc/init_hns_db;',
    creates => '/etc/init_hns_db',
    path => ['/usr/bin'],
  }
}
