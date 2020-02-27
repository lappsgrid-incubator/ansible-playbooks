#!/usr/bin/env bash
set -e

if [[ "$#" = 0 ]] ; then
    IPS="149.165.156.140 149.165.157.140"
elif [[ "$1" = "both" ]] ; then
    IPS="149.165.156.140 149.165.157.140"
elif [[ "$1" = "156" ]] ; then
    IPS="149.165.156.140"
elif [[ "$1" = "157" ]] ; then
    IPS="149.165.157.140"
else
    IPS=$@
fi

for ip in $IPS ; do
	echo $ip
	ssh-keygen -R $ip
	ssh-keyscan $ip >> ~/.ssh/known_hosts
done

