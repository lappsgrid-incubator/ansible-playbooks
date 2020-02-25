#!/usr/bin/env bash

if [[ "$#" = 0 ]] ; then
    IPS=149.165.156.140
else
    IPS=$@
fi

for ip in $IPS ; do
	echo $ip
	ssh-keygen -R $ip
	ssh-keyscan $ip >> ~/.ssh/known_hosts
done

