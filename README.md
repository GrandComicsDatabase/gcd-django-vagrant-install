# gcd-django-vagrant-install
Scripts to setup a local development environment for the [Grand Comics Database](http://www.comics.org/) website ([gcd-django](https://github.com/GrandComicsDatabase/gcd-django/)) using [Vagrant](https://www.vagrantup.com/).


## Requirements

You need to install [Vagrant](https://www.vagrantup.com/downloads.html) and [Virtualbox](https://virtualbox.org/wiki/Downloads) (or VMWare Fusion or Parallels Desktop).
Then, it's recommended to install the vb-guest plugin for Vagrant:
```shell
$ vagrant plugin install vagrant-vbguest
```

## Installation

After installing Vagrant, simply run:

```shell
$ cd /path/to/your/gcd-django-vagrant-install/parent-directory
$ git clone https://github.com/adia/gcd-django-vagrant-install
$ vagrant up --provision
$ vagrant ssh
(vm)$ cd /vagrant && make install
```

## Update

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ git pull
$ vagrant up --provision
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