# Ansible Playbook: Galaxy

Installs and configures a LAPPS Grid [Galaxy](https://galaxyproject.org) instance.  This is not to be confused with [Ansible Galaxy](https://ansible.galaxy.com), which is the name of the program Ansible uses for dependency management.


## TL;DR

``` 
$> ansible-galaxy install --roles-path ./roles -r requirements.txt
$> ansible-playbook setup.yml
$> ansible-playbook -i hosts galaxy.yml
```
## Prerequisites

The following roles are used from Ansible Galaxy.

1. [geerlingguy.postgresql](https://github.com/geerlingguy/ansible-role-postgresql) role for installing Postgresql

The above roles and can be installed locally with the `requirements.yml` file.

``` 
$> ansible-galaxy install --roles-path ./roles -r requirements.yml
```

The `--roles-path` parameter causes the roles to be downloaded and saved into the `./roles` directory.  If you omit this parameters the roles will be downloaded to  `~/.ansible/roles`.

## Inventory

Modify the included `hosts` file or edit your `/etc/ansible/hosts` file to include the IP address(es) of your Galaxy server(s). The `jetstream.yml` playbook configures the instances to use the `lappsgrid-shared-key.pem` for the `root` user. 

If you use the `jetstream.yml` playbook to provision a Jetstream instance be use to change the IP addresses in `vars/jetstream.yml` as well 

## Playbooks

Configuring a Galaxy server involves a number of steps, each performed by a separate playbook:

1. **setup.yml**<br/> generate a random database password and the *secrets* used by Galaxy.
1. **jetstream.yml**<br/>configure a Jetstream instance.  For testing and development one Ubuntu and one CentOS instance are provisioned.<br/> **note** Newly created instances on Jetstream will spend some time (several minutes) updating so it is best to wait a short time before running the other playbooks to prevent apt/yum complaining about their lock files being in use.
1. **packages.yml**<br/> install all required packages including Java 8
1. **postgresql.yml**<br/> install Postgresql and set up the Galaxy database
1. **groovy.yml**<br/> install Groovy
1. **lsd.yml**<br/> install LSD
1. **github.yml**<br/> clone Galaxy from the GitHub repositories
1. **service.yml**<br/> configure Galaxy as a system service.
1. **apache.yml**<br/> install Apache2

There is an uber-playbook `galaxy.yml` that performs all of the above steps except the `jetstream.yml`.

``` 
$> ansible-playbook galaxy.yml
```

#### Optional Parameters

By default the `galaxy.yml` playbook will check out the *master* branch from the Mods repository and the *lapps* branch from the Galaxy repository.  These can be overridden by setting the `galaxy_branch` and `mods_branch` variables when calling the playbook:

``` 
$> anisble-playbook galaxy.yml -e 'galaxy_branch=testing mods_branch=develop'
``` 

## Notes and Caveats

Make sure you have sourced the correct openrc.sh file to be able to use the `jetstream.yml` and `jetstream-delete.yml` playbooks.

This playbook configures and enables `init.d` startup scripts for Galaxy, but the Galaxy service is not started by the playbook. The first time a Galaxy instance is started it uses `pip` to download the internet and then performs +170  transformations to update the database, which causes the ansible to timeout. Therefore the first Galaxy start up must be done manually.

``` 
$> cd /home/galaxy/galaxy
$> sudo -u galaxy ./run.sh
```

Be sure to run the `./run.sh` script as the galaxy user so files don't end up being owned by *root* which will cause problems when the service tries to start.

## Troubleshooting

#### Python

Ansible will try to auto-detect the Python version available on the target systems which can cause problems when one system has Python 3 available (i.e. Ubuntu 18) and the other does not (i.e. CentOS 7).  Rather than doing a lot of system sniffing to ensure the right Postrgresql Python driver is installed we just force Ansible to use Python 2 by setting `ansible_python_interpreter=/usr/bin/python`. If you get errors regarding `psycopg` ensure that the Python interpreter is being set, ideally in your inventory file. 

#### SSH

The 