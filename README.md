# GCD Django Box
This repository is a set of puppet modules and scripts to setup a local development environment for the [Grand Comics Database](http://www.comics.org/) website ([gcd-django](https://github.com/GrandComicsDatabase/gcd-django/)) using [Vagrant](https://www.vagrantup.com/).

## References

* [Grand Comics Database website](http://www.comics.org)
* [Grand Comics Database documentation](http://docs.comics.org/wiki/Main_Page)
* Grand Comics Database Google groups:
   * [Main group](https://groups.google.com/forum/#!forum/gcd-main)
   * [Technical group](https://groups.google.com/forum/#!forum/gcd-tech)

## Requirements

You need to install these applications:

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [Virtualbox](https://virtualbox.org/wiki/Downloads)
* [git](http://git-scm.com)

### Providers

You can use other providers like [VMWare Fusion](http://www.vmware.com/products/fusion) or [Parallels Desktop](http://www.parallels.com/fr/products/desktop/) with this box but we only provide support for VirtualBox.

The official documentation to manage providers with Vagrant is available [here](https://docs.vagrantup.com/v2/providers).

###  Windows users

The easiest way to install `git` on Windows and manage repositories is to use the official application of Github.com available [here](https://windows.github.com/). It provides also some tools like `PowerShell`, `msysGit` and `posh-git`.
PowerShell console allows you to proceed commands like Unix users, as needed here.

The official documentation to get started with Github for Windows is available [here](https://help.github.com/articles/getting-started-with-github-for-windows).

## Installation

To get started with the GCD Django Box, simply run:

```shell
$ cd /path/to/your/gcd-django-vagrant-install/parent-directory
$ git clone https://github.com/adia/gcd-django-vagrant-install
$ cd gcd-django-vagrant-install
$ cp ./puppet/environments/local/parameters_private.yaml.sample ./puppet/environments/local/parameters_private.yaml
$ vagrant up --provision
$ vagrant ssh
```

Once connected in your VM, run:

```shell
(vm)$ cd /vagrant && make install
```

Congratulations, just after a little while, you should have a new box running with a fresh GCD development installation listening on [localhost:8000](http://localhost:8000/) - simply visit this link to test it.

Preinstalled accounts are:

Username | Password
---------|---------
**admin** | **admin**
**editor** | **editme**
**test@comics.org** | **test**


**Notes about the parameters_private.yaml file**

* This file helps you define custom parameters for:
   * Your Gihub.com account information (name / e-mail)
   * The theme for oh-my-zsh (the default theme is `gianu`)

**Other stuff**

* The [oh my zsh](http://ohmyz.sh) framework to pimp your `zsh` configuration.
* The [tig](http://jonas.nitro.dk/tig/manual.html) command is installed to help you deal with `git` in command line.

### Load data

If you want to load real data in your box, you can follow these steps:

1. Sign in to http://www.comics.org/download/ 
2. Download the last **MySQL** dump (for instance: "Data last updated: MySQL: 2015-04-15 03:40:42")
3. Once the file `current.zip` is downloaded, unzip it in the root of your `gcd-django-vagrant-install` directory (for instance, you should have: **2015-04-15.sql** )
4. Then, if you have the file **2015-04-15.sql**, execute these commands:

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ vagrant ssh
(vm)$ cd /vagrant && make load-data MYSQL=2015-04-15.sql
```

### Index data

If you want to index data in your box, run:

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ vagrant ssh
(vm)$ cd /vagrant && make index-data
```

## Daily usage

### Start the VM

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ vagrant up
```

### Exit from the VM

```shell
(vm)$ exit
```

### List available commands

```shell
(vm)$ cd /vagrant && make help
```

### Stop the VM

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ vagrant halt
```

## Specific usage

### Update the GCD Django Box

To apply Puppet modifications (like a new theme for oh-my-zsh), run:

* If your box is halted:

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ git pull
$ vagrant up --provision
```

* If your box is already up:

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ git pull
$ vagrant provision
```