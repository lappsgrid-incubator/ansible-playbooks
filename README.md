# Ansible Playbooks

This repository contains [Ansible Playbooks](https://github.com/ansible/ansible) for configuring various LAPPS Grid servers and services.

1. **solr-cloud**<br/> configure a Solr Cloud with a Zookeeper ensemble.
1. **shibboleth**<br/> configure a Shibboleth Service Provider
1. **openstack**<br/> provision servers on Jetstream.
1. **galaxy**<br/> set up a new LAPPS Galaxy instance.

## Requirements

The Ansible *command host*; that is, the machine where you will run the Ansible commands must have
- Ansible (see below)
- Python (2.7, or 3.6+)
- SSH

The *target* machines must have:
- Python (2.7 or 3.6+)
- SSH

If using the `openstack` playbooks or the `jetstream` playbooks then you must also `source` the `openrc.sh` file you obtained from Jetstream.  The `openstack` and `jetstream` playbooks use the *lappsgrid-shared-key.pem* on IU instances and the *tacc-shared-key.pem* on TACC instances..

## Installing Ansible

There are [many ways to install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html), but likely the easiest is to use `pip`:


``` 
$> pip install --user ansible
```