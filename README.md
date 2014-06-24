puppet
======
Server install:
1. setup your hostname first - for the right certificate.

2. setup puppet master.
# replace trusty with precise if you're ubuntu 12.04
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
sudo dpkg -i puppetlabs-release-trusty.deb
wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
sudo dpkg -i puppetlabs-release-precise.deb
sudo apt-get update
apt-get install -y puppetmaster git

3. git clone.
cd /root && git clone https://github.com/dec1985/puppet.git puppet
rm -rf /etc/puppet && mv /root/puppet /etc

4. fix the hiera.
rm /etc/hiera.yaml
ln -s /etc/puppet/hiera.yaml /etc/hiera.yaml
mkdir /etc/puppet/hieradata/
vi /etc/puppet/hieradata/global.yaml

5. restart your puppetmaster.
/etc/init.d/puppetmaster restart

6. apply itself.

Client install:
change your machien's name: echo NAME > /etc/hostname; hostname -F /etc/hostname
echo '10.162.194.113    puppet-master' >> /etc/hosts
apt-get install -y puppet
Fix puppet.conf: pluginsync=true
puppet agent -t --waitforcert --server puppet-master
