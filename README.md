puppet
======
Server install:
1. setup your hostname first - for the right certificate.

2. setup puppet master.
# replace trusty with precise if you're ubuntu 12.04
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
sudo dpkg -i puppetlabs-release-trusty.deb
sudo apt-get update
apt-get install puppetmaster

3. git clone.
cd /etc
git clone https://github.com/dec1985/puppet.git puppet

4. fix the hiera.
rm /etc/hiera.yaml
ln -s /etc/puppet/hiera.yaml /etc/hiera.yaml

Client install:
change your machien's name: echo NAME > /etc/hostname; hostname -F /etc/hostname
apt-get install puppet
puppet agent -t --waitforcert --pluginsync --server YOUR_SERVER
