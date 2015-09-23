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
$ git clone --recurse-submodules https://github.com/GrandComicsDatabase/gcd-django-vagrant-install
$ cd gcd-django-vagrant-install
$ cp ./puppet/environments/local/parameters_private.yaml.sample ./puppet/environments/local/parameters_private.yaml
```

Edit parameters_private.yaml to have your GitHub username and email.
You can also optionally add some zsh or vim customizations.
Then run:

```shell
$ vagrant up --provision
$ vagrant ssh
```

If you are using the Windows or Mac GitHub client, it should handle recursively checking out the submodules automatically.  The provisioning will work even if the submodules are not checked out, but the resulting git repo will only function properly within the VM.  Checking out the submodules before provisioning results in a repo that works in both the host and the VM.

To run off of `master`, once connected in your VM, run:

```shell
(vm)$ cd /vagrant && make install
```

To run off of a different branch, first configure your tracking branch, then check it out, and then run make install:

```shell
(vm)$ cd /vagrant/www
(vm)$ git branch --track devel origin/devel
(vm)$ git checkout devel
(vm)$ cd /vagrant && make install
```

Running make install on the branch only really matters if your python packages or database migrations are different.

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
   * Some optional customization file contents

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

### Index data for the search engine

Most of the site's search features run MySQL queries directly.  However,
the "Everything" search and a few other places use Elasticsearch, which
requires a separate search index.  If you want to use Elasticsearch,
run the following command to build the index:

```shell
$ cd /path/to/your/gcd-django-vagrant-install/directory
$ vagrant ssh
(vm)$ cd /vagrant && make index-data
```

*NOTE*: You will need to set `USE\_ELASTICSEARCH=True` in your
`/vagrant/www/settings\_local.py` file in order for the site to use this index.

Indexing the public data dump takes much, much longer than loading it, so you
might want to run this command overnight.
This command *drops all existing search engine data* and rebuilds it from scratch,
so you generally do not want to use it unless you have completely changed your
data set.

## Development usage

### The development tree

The [gcd-django repository](https://github.com/GrandComicsDatabase/gcd-django)
is cloned at `/vagrant/www`, and you can do your development work there.
See the README for that repository for a guide to the branches and other
information.

### Starting and stopping django

Normally, Django should pick up changes that you make automatically.  However,
if you have restart it for some reason, `gcd-django` is registered as an
`init(8)` service, so `start gcd-django`, `stop gcd-django`, `restart gcd-django`,
etc. all work.  `man initctl` for more information on the avialable commands.

You can see exactly what is going on for this in `/etc/init/gcd-django.conf`

### Logs

You'll find your web server log in `/vagrant/gcd-django.log`

### Python Environment

The virtualenv used to run the server is located at `/usr/local/virtualenv`
Although see https://github.com/GrandComicsDatabase/gcd-django-vagrant-install/issues/4
for an issue with that installation and plans to move it to `/opt`

## Daily VM usage

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
