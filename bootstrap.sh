# Default root MySQL password
MYSQL_PASSWORD=gcd
echo "mysql-server-5.5 mysql-server/root_password password ${MYSQL_PASSWORD}
mysql-server-5.5 mysql-server/root_password seen true
mysql-server-5.5 mysql-server/root_password_again password ${MYSQL_PASSWORD}
mysql-server-5.5 mysql-server/root_password_again seen true
" | sudo debconf-set-selections

# Add elasticsearch source and key if needed
if ! grep -q elasticsearch /etc/apt/sources.list; then
    echo 'deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main' | sudo tee -a /etc/apt/sources.list
    wget -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
fi

sudo apt-get update

# Check if elasticsearch is going to be installed
if ! dpkg-query -W elasticsearch; then
    ELASTICSEARCH=true
fi

# Install required packages
DEBIAN_FRONTEND=noninteractive sudo -E apt-get install -y --force-yes \
    mysql-server git python-pip csstidy python-virtualenv build-essential \
    libmysqlclient-dev python-dev libjpeg-dev libicu-dev openjdk-7-jre elasticsearch

# If elasticsearch was installed, add it to default jobs
if [ -n "$ELASTICSEARCH" ]; then
    sudo update-rc.d elasticsearch defaults 95 10
fi
sudo service elasticsearch status || sudo service elasticsearch start

# Set MySQL default storage engine and create 'gcd' database if needed
if ! grep -q default-storage-engine /etc/mysql/my.cnf; then
    sudo perl -i -pe 's/\[mysqld]/$&\ndefault-storage-engine = InnoDB\n/'  /etc/mysql/my.cnf
fi
sudo service mysql restart
echo 'CREATE DATABASE gcd IF NOT EXISTS DEFAULT CHARACTER SET utf8' |mysql -u root -p"$MYSQL_PASSWORD"

# Download GCD code and required Python packages in virtualenv
if [ -d /vagrant/gcd-django ]; then
    cd /vagrant/gcd-django
    git pull
else
    git clone git://github.com/GrandComicsDatabase/gcd-django.git /vagrant/gcd-django
fi
if [ -d /vagrant/python-graph ]; then
    cd /vagrant/python-graph
    git pull
else
    git clone https://github.com/pmatiello/python-graph /vagrant/python-graph
fi
[ -d /vagrant/virtualenv ] || virtualenv --system-site-packages /vagrant/virtualenv
source /vagrant/virtualenv/bin/activate
pip install -U pip requests
pip install /vagrant/python-graph/core
cd /vagrant/gcd-django
pip install -U -r requirements.txt --allow-all-external --allow-unverified rbtools --allow-unverified python-graph-core

# GCD site initialization
mkdir -p media/img/gcd/{new_covers,covers_by_id}
[ -f settings_local.py ] || cp ../settings_local.py .
./manage.py syncdb --migrate --noinput
./manage.py loaddata users
export DJANGO_SETTINGS_MODULE=settings
python <../initialize_countstats.py
./manage.py rebuild_index --noinput

# Make gcd-django start automatically via Upstart
[ -f /etc/init/gcd-django.conf ] || sudo cp ../gcd-django.conf /etc/init
status gcd-django | grep -q start || sudo start gcd-django
