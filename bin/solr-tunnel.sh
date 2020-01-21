#!/usr/bin/env bash

# Opens a SSH tunnel to one of the Solr instances

# For security reasons Solr is not visible to the outside world, that is,
# the instances do not have public IP addresses.  Therefore to access the Solr
# web UI we need to create an SSH tunnel through a server that:
# a) has a public IP address.
# b) is on the same private network as the Solr instances.
#
# To date all instances are on the same private network so only 'a' from
# above is important.

PORT=8983
SOLR_1=10.1.1.9
SOLR_2=10.1.1.45

HOST=129.114.17.81 # the Ansible command host
SOLR_IP=$SOLR_1
if [[ $1 = 2 ]] ; then
  SOLR_IP=$SOLR_2
fi

ssh -i ~/.ssh/tacc-shared-key.pem ubuntu@$HOST -L $PORT:$SOLR_IP:$PORT
