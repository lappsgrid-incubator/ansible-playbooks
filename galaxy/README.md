# Ansible Playbook: Galaxy

Installs and configures a LAPPS Grid [Galaxy](https://galaxyproject.org) instance.  This is not to be confused with [Ansible Galaxy](https://ansible.galaxy.com), which is the name of the program Ansible uses for dependency management.

## Prerequisites

The following roles are used from Ansible Galaxy.

1. [geerlingguy.postgresql](https://github.com/geerlingguy/ansible-role-postgresql) role for installing Postgresql

The above roles and can be installed locally with the `requirements.yml` file.

``` 
$> ansible-galaxy install --roles-path ./roles -r requirements.yml
```

The `--roles-path` parameter causes the roles to be downloaded and saved into the `./roles` directory.  If you omit this parameters the roles will be downloaded to  `~/.ansible/roles`.

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

The `galaxy.yml` playbook does not run the `setup.yml` playbook by default. To include it set `setup=yes`. 

``` 
$> ansible-playbook galaxy.yml -e 'setup=yes'
```

By default the `galaxy.yml` playbook will checkout the *master* branch from the Mods repository and the *lapps* branch from the Galaxy repository.  These can be overridden by setting the `galaxy_branch` and `mods_branch` variables when calling the playbook:

``` 
$> anisble-playbook galaxy.yml -e 'galaxy_branch=testing mods_branch=develop'
``` 

## Troubleshooting

Make sure you have sourced the correct openrc.sh file to be able to communicate to the Jetstream instances over SSH.

