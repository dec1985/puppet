from flask import Flask
app = Flask(__name__)
app.debug = True
#app.config.update(
#  SERVER_NAME="172.20.4.5:7401",
#)

@app.route("/<hostname>")
def hello(hostname):
    return """
#!/bin/bash

echo %s > /etc/hostname
hostname -F /etc/hostname

ntpdate ntp.ubuntu.com
apt-get update
apt-get install -y puppet

cat > /etc/puppet/puppet.conf << EOF
[main]
logdir=/var/log/puppet
vardir=/var/lib/puppet
ssldir=/var/lib/puppet/ssl
rundir=/var/run/puppet
factpath=/lib/facter

[master]
# These are needed when the puppetmaster is run by passenger
# and can safely be removed if webrick is used.
ssl_client_header = SSL_CLIENT_S_DN
ssl_client_verify_header = SSL_CLIENT_VERIFY
storeconfigs = true
storeconfigs_backend = puppetdb

[agent]
report=true
listen=true
pluginsync=true
server=fred-master.lan.happylatte.com
masterport=7400
EOF

puppet agent -t

""" % hostname

if __name__ == "__main__":
    app.run(
  host='0.0.0.0',
  port=7401,
)
