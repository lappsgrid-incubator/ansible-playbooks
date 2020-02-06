# Solr Cloud Playbooks

These are the Ansible playbooks used to configure a Solr Cloud running on Jetstream/TACC. With these playbooks you can:

- create (and destroy) the Jetstream instances.
- configure Zookeeper and Solr

Currently the playbooks **do not** create the disk volumes that are attached to the Solr instances.  These volumes **must** be created separately and **must** be named *solr-1*, *solr-2*, ... *solr-n* where *n* is the number of Solr instance to be created.

## Notes

To use any of the playbooks in the *openstack* directory you **must** `source` the *openrc.sh* file obtained from [https://tacc.jetstream-cloud.org](https://tacc.jetstream-cloud.org).  After logging in to Jetstream you can download the *openrc.sh* file by clicking on your username (top right of the user interface) and selecting *OpenStack RC File v3*

For security reasons none of the Zookeeper or Solr instances should have pubic IP addresses assigned. To run these playbooks you will need to SSH to one of the servers with public IP addresses; 129.114.17.81 has been set up for just this purpose.  This server will be referred to as the *"Ansible command host"*.

## TL;DR (Executive Summary)

```
# On your local machine (or any machine with your Jetstream credentials) 
$> ansible-playbook openstack/cloud-create.yml

# [task] Edit /etc/ansible/hosts on the Ansible command host.

# The remaining command are run on the Ansible command host.
$> ansible-playbook download.yml
$> ansible-playbook etc_hosts.yml
$> ansible-playbook zookeeper.yml
$> ansible-playbook solr.yml
```

There is also an *uber-playbook* called *solr-cloud.yml* that simply calls the above playbooks in order.  So the four commands above can be accomplished with

``` 
$> ansible-playbook solr-cloud.yml
```

# Complete Instructions

## Create the cluster

Run the *openstack/cloud-create.yml* playbook to create the Jetstream instances.  By default three *'tiny'* instances will be created to run the Zookeeper nodes and two *'large'* instances will be created for the Solr nodes.  To change the number of instances created edit the *openstack/variables.yml* file and change the `solr_ids` and `zk_ids` as needed.  Is is not required that the `zk_ids` or `solr_ids` be in sequence or start at 1, but it is much easier if they do.

```yaml
zk_ids: [1, 2, 3]
solr_ids: [1, 2]
```

The values in the variables file can also be overridden on the command line when running the playbook.

``` 
$> ansible-playbook openstack/cloud-create.yml -e 'solr_ids=[1, 2, 3, 4] zk_ids=[1, 2, 3, 4, 5]
```

The *network*, *security group*, and *key pair* must have been created previously on Jetstream.

**TBD** Automate the creationg of networks, security groups, and keys with Anisble Playbooks!

**NOTE** The playbook to provision the Jetstream instances **must** be run on a machine with your OpenStack credentials (openrc.sh). **Do not** upload your Jetstream credentials to a Jetstream host! 

## Inventory

After the instances have been created their IP addresses must be added to the Ansible inventory.  The easiest way to add the servers to the inventory is to edit the `/etc/ansible/hosts` file on the Ansible command host.

```ini
[zookeeper]
zk1 zoo_id=1 ansible_host=10.1.1.21
zk2 zoo_id=2 ansible_host=10.1.1.28
zk3 zoo_id=3 ansible_host=10.1.1.25

[solr]
solr1 ansible_host=10.1.1.26
solr2 ansible_host=10.1.1.20

[zksolr]
zk1
zk2
zk3
solr1
solr2

[zookeeper:vars]
ansible_ssh_private_key_file=/home/ubuntu/.ssh/tacc-shared-key.pem

[solr:vars]
ansible_ssh_private_key_file=/home/ubuntu/.ssh/tacc-shared-key.pem
```

Three server groups are created *[solr]* for working with the Solr nodes, *[zookeeper]* for working with the Zookeeper nodes, and *[zksolr]* for working with all the nodes in the cluster.

Each Zookeeper node also has a *zoo_id* defined that will be used to generate the `$ZK_HOME/conf/myid` file that is used by Zookeeper.

Group variables are also defined to specify the SSH key file that should be used when connecting to the servers.

#### Caveats and Gotchas

Ansible works with SSH and before we can connect to any of the servers we need to add their SSH keys to the `.ssh/known_hosts` file on the Ansible command host.  The easiest way to reset all the SSH keys is to use the `ssh-reset.sh` Bash script and pass it the last octet (number) from the server's IP address:

``` 
$> ./ssh-reset.sh 21 25 28 20 26 
```

## Download Solr and Zookeeper

During testing and development downloading files and verifying their checksums was refactored into a separate playbook to avoid the cost of repeatedly downloading the same files.

``` 
$> ansible-playbook download.yml
```

**TODO** Downloading and verifying the tarballs should be refactored back into the respective playbooks.


## /etc/hosts

After all the nodes have been created the `/etc/hosts` file on each is updated so nodes can refer to each other by hostname.

```
$> ansible-playbook etc_hosts.yml
```

The playbook to generate the `/etc/hosts` file is so simple (one task) that it can be run as an *ad-hoc* command:

``` 
$> ansible zkhosts -m template -b -a 'src=templates/hosts.j2 dest=/etc/hosts'
```

## Install software

Two playbooks are provided to install the required software, one for Zookeeper and the other for Solr.  The Zookeeper playbook should be run first as Solr will look for Zookeeper when it starts.

``` 
$> ansible-playbook zookeeper.yml
$> ansible-playbook solr.yml
```

## Solr UI

Since the Solr instances do not have public IP addresses you will have to use an SSH tunnel to connect to the Solr user interface. Assuming we will use the Ansible command host (currently 129.117.17.81) to tunnel to the solr-1 instance (currently 10.1.1.26) we would run the following on our local machine:

``` 
$> ssh -i ~/.ssh/tacc-shared-key.pem ubuntu@129.117.17.81 -L 8983:10.1.1.26:8983
```

Now the Solr UI will be available on [http://localhost:8983/solr](http://localhost:8983/solr) in a browser.
