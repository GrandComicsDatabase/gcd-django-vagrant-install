# gcd-django-vagrant-install
Scripts to setup a local development environment for the [Grand Comics Database](http://www.comics.org/) website ([gcd-django](https://github.com/GrandComicsDatabase/gcd-django/)) using [Vagrant](https://www.vagrantup.com/).

## Requirements

You need to install these applications:

* [Vagrant](https://www.vagrantup.com/downloads.html)
* A provider:
** As default [Virtualbox](https://virtualbox.org/wiki/Downloads) 
** VMWare Fusion,
** Parallels Desktop.
* `git`

**Note for the Windows user**:

The easiest way to do install `git` on Windows is to use the official application of Github.com available [here](https://windows.github.com/).
Use the `git shell` provided with the application to be able to proceed commands like Unix users.

## Installation

Once `Vagrant`, `git` and a provider installed, simply run:

```shell
$ cd /path/to/your/gcd-django-vagrant-install/parent-directory
$ git clone https://github.com/adia/gcd-django-vagrant-install
$ cd gcd-django-vagrant-install
$ cp ./puppet/environments/local/parameters_private.yaml.sample ./puppet/environments/local/parameters_private.yaml
$ vagrant up --provision
$ vagrant ssh
(vm)$ cd /vagrant && make install
```

**Notes for the parameters_private.yaml**

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
3. Once the file `current.zip` is downloaded, unzip it in the root of your `gcd-django-vagrant-install` directory (for instance, you should have: **2015-04-15.sql** )
4. Then, if you have the file **2015-04-15.sql**, execute these commands:

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ vagrant up
(vm)$ cd /vagrant && make load-data MYSQL=2015-04-15.sql
```

## Daily usage

### Start the VM

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ vagrant up
```

In this directory and, after a little while, you should have a VirtualBox VM running a gcd-django development installation listening on [localhost:8000](http://localhost:8000/) - simply visit this link to test it.

### Exit from the VM

```shell
(vm)$ exit
```

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