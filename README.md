# gcd-django-vagrant-install
Scripts to setup a local development environment for the [Grand Comics Database](http://www.comics.org/) website ([gcd-django](https://github.com/GrandComicsDatabase/gcd-django/)) using [Vagrant](https://www.vagrantup.com/).


## Installation

After installing Vagrant, simply run:

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ git clone ..... .
$ vagrant plugin install vagrant-vbguest
$ git submodule update --init
$ vagrant up
$ vagrant provision
$ vagrant halt
```

## Update

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ git pull --rebase
$ vagrant up --provision
$ vagrant halt
```

## Daily use

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ vagrant up
$ vagrant halt
```

in this directory and, after a little while, you should have a VirtualBox VM running a gcd-django development installation listening on [localhost:8000](http://localhost:8000/) - simply visit this link to test it.

Preinstalled accounts are (username / password): 

* **admin** / **admin**
* **editor** / **editme**
* **test@comics.org** / **test**