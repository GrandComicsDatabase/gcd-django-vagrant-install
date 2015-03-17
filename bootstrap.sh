sudo apt-get update

# Default root MySQL password
MYSQL_PASSWORD=gcd
echo "mysql-server-5.5 mysql-server/root_password password ${MYSQL_PASSWORD}
mysql-server-5.5 mysql-server/root_password seen true
mysql-server-5.5 mysql-server/root_password_again password ${MYSQL_PASSWORD}
mysql-server-5.5 mysql-server/root_password_again seen true
" | sudo debconf-set-selections

# Install required packages
DEBIAN_FRONTEND=noninteractive sudo -E apt-get install -y --force-yes \
    mysql-server git python-pip python-pyicu csstidy python-virtualenv \
    libmysqlclient-dev python-dev libjpeg-dev openjdk-7-jre

# Set MySQL default storage engine and create 'gcd' database
sudo perl -i -pe 's/\[mysqld]/$&\ndefault-storage-engine = InnoDB\n/'  /etc/mysql/my.cnf
sudo service mysql restart
echo 'CREATE DATABASE gcd DEFAULT CHARACTER SET utf8' |mysql -u root -p"$MYSQL_PASSWORD"

# Install Elasticsearch
wget -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
echo 'deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main' | sudo tee -a /etc/apt/sources.list
sudo apt-get update && sudo apt-get install elasticsearch
sudo update-rc.d elasticsearch defaults 95 10
sudo service elasticsearch start

# Download GCD code and required Python packages in virtualenv
[ -d /vagrant/gcd-django ] || git clone git://github.com/GrandComicsDatabase/gcd-django.git /vagrant/gcd-django
[ -d /vagrant/virtualenv ] || virtualenv --system-site-packages /vagrant/virtualenv
[ -d /vagrant/python-graph ] || git clone https://github.com/pmatiello/python-graph /vagrant/python-graph
source /vagrant/virtualenv/bin/activate
pip install -U pip requests
pip install /vagrant/python-graph/core
cd /vagrant/gcd-django
pip install -r requirements.txt --allow-all-external --allow-unverified rbtools --allow-unverified python-graph-core

# GCD site initialization
mkdir -p media/img/gcd/{new_covers,covers_by_id}
cp ../settings_local.py .
./manage.py syncdb --migrate --noinput
./manage.py loaddata users
export DJANGO_SETTINGS_MODULE=settings
python <../initialize_countstats.py
./manage.py rebuild_index --noinput

# Make gcd-django start automatically via Upstart
sudo cp ../gcd-django.conf /etc/init
sudo start gcd-django
