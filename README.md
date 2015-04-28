# gcd-django-vagrant-install
Scripts to setup a local development environment for the [Grand Comics Database](http://www.comics.org/) website ([gcd-django](https://github.com/GrandComicsDatabase/gcd-django/)) using [Vagrant](https://www.vagrantup.com/).


## Requirements

You need to install [Vagrant](https://www.vagrantup.com/downloads.html) and [Virtualbox](https://virtualbox.org/wiki/Downloads) (or VMWare Fusion or Parallels Desktop).
Then, it's recommended to install the vb-guest plugin for Vagrant:
```shell
$ vagrant plugin install vagrant-vbguest
```

## Installation

Once Vagrant and a provider installed, simply run:

```shell
$ cd /path/to/your/gcd-django-vagrant-install/parent-directory
$ git clone https://github.com/adia/gcd-django-vagrant-install
$ cd gcd-django-vagrant-install
$ cp ./puppet/environments/local/parameters_private.yaml.sample ./puppet/environments/local/parameters_private.yaml
$ vagrant up --provision
$ vagrant ssh
(vm)$ cd /vagrant && make install
```

*Notes*

* Providing your Gihub.com account information (name / e-mail) in the file `parameters_private.yaml` allows you to commit directly from the box.
* The [tig](http://jonas.nitro.dk/tig/manual.html) command is installed to help you deal with git.


## Update

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ git pull
$ vagrant up --provision
```

## Load data

If you want to load data in your box, you can follow these steps:

1. Sign in to http://www.comics.org/download/ 
2. Download the last **MySQL** dump (for instance: "Data last updated: MySQL: 2015-04-15 03:40:42")
3. Once the current.zip is downloaded, unzip it in the root of your "gcd-django-vagrant-install" directory (for instance, you should have: **2015-04-15.sql** )
4. Then, execute theses commands:

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ vagrant up
(vm)$ cd /vagrant && make load-data MYSQL=YEAR-MONTH-DAY.sql # Adapt {YEAR/MONTH/DAY} with the name of your downloaded file
```

## Daily usage

### Start the VM

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ vagrant up
```

In this directory and, after a little while, you should have a VirtualBox VM running a gcd-django development installation listening on [localhost:8000](http://localhost:8000/) - simply visit this link to test it.

### Stop the VM

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ vagrant halt
```

Preinstalled accounts are:

Username | Password
---------|---------
**admin** | **admin**
**editor** | **editme**
**test@comics.org** | **test**