class python_env {
  file { '/opt/env':
    ensure => 'directory',
    owner => 'root',
    group => 'root',
    # so everyone can create sub folder.
    mode => 0777,
  }->
  class { 'python':
    pip => true,
    dev => true,
    virtualenv => true,
  }->


  # reids server
  python::virtualenv { '/opt/env/redisenv':
    ensure => present,
    version => '2.7',
    distribute => false,
  }->
  python::pip { ['redis_shard']:
    virtualenv => '/opt/env/redisenv',
    environment => 'PIP_PYPI_URL=https://highnoon:JstSmthngNwO_O@pypi.happylatte.com/private/',
  }

  # sso server
  python::virtualenv { '/opt/env/ssoenv':
    ensure => present,
    version => '2.7',
    distribute => false,
  }->
  # Note: happysso need Package['postgresql-server-dev-9.1']
  package { 'postgresql-server-dev-9.1':
    ensure => present,
  }->
  python::pip { ['happysso', 'greenlet', 'configobj']:
    virtualenv => '/opt/env/ssoenv',
    environment => 'PIP_PYPI_URL=https://highnoon:JstSmthngNwO_O@pypi.happylatte.com/private/',
  }

  # hns - for monitor
  python::virtualenv { '/opt/env/hnsenv':
    ensure => present,
    version => '2.7',
    distribute => false,
  }->
  python::pip { ['hnMonitor', 'sallylog']:
    virtualenv => '/opt/env/hnsenv',
    environment => 'PIP_PYPI_URL=https://highnoon:JstSmthngNwO_O@pypi.happylatte.com/private/',
  }
  # hns
  file { '/home/highnoon/log':
    ensure => directory,
    owner => 'highnoon',
    group => 'highnoon',
  }
  python::virtualenv { '/home/highnoon/hnenv':
    ensure => present,
    version => '2.7',
    systempkgs => false,
    distribute => true,
    owner => 'highnoon',
    group => 'highnoon',
    timeout => 0,
  }->
  python::pip { ['argparse==1.2.1',
                 'texttable==0.8.1',
                 'pytz==2012c',
                 'biplist==0.4',
                 'ujson==1.18',
                 'dnspython==1.10.0',
                 'redis==2.2.4',
                 'pycrypto==2.4.1',
                 'pyasn1==0.0.13',
                 'greenlet==0.4.0',
                 'pyOpenSSL==0.13',
                 'guppy==0.1.9',
                 'eventlet==0.9.16',
                 'configobj==4.7.2',
                 'Jinja2==2.1.1',
                 'mock==0.6.0',
                 'psycopg2==2.4.5',
                 'simplejson==2.0.9',
                 'pyzmq==2.2.0',
                 'zope.interface==4.0.1',
                 'Twisted==12.1.0',
                 'txZMQ==0.6.1',
                 'pyYAML==3.10',
                 'protobuf==2.4.1',
                 'pycountry==1.4',
                 'geoip2==0.5.1',
                 'pyfacebook-happylatte==1.0a2',
                 'Thrift-happylatte-py==0.8.0',
                 'sallyconf==1.1.0',
                 'hnProtocol==1.4.0.4',
                 'hnYellow==2.4.2',
                 'redisd==0.3.0',
                 'hnRedis==0.3.8',
                 'hnMonitor==1.0.4',
                 'hnDB==1.2.2',
                 'sallyutils==0.16.15',
                 'sallylog==0.3.3',
                 'hnHook==1.2.12',
                 'hndao==0.5.7',
                 'hnStrings==1.0.7',
                 'hnLadder==0.5.30.7',
                 'hnAPN==1.1.5',
                 'hnTel==0.3.11',
                 'hnJournal==0.4.5',
                 'hnMunin==0.5.10',
                 'hnStats==0.1.12',
                 'etYellowUtils==0.5.4-r2',
                 'notification==0.3.5',
                 'M2Crypto-happylatte==0.22r739.dev-r739',
                 'hnCompetition==0.2.29',
                 'hnItems==1.0.1',
                 'chatlib==0.3.18',
                 'happybroker==0.6.30',
                 'hnCasino==0.10.6',
                 'hnMission==0.0.45.32',
                 'statsproto==0.0.32']:
    virtualenv => '/home/highnoon/hnenv',
    owner => 'highnoon',
    environment => ['PIP_PYPI_URL=https://highnoon:JstSmthngNwO_O@pypi.happylatte.com/private/',
                    'ARCHFLAGS="-arch i386 -arch x86_64"'],
  }
}
