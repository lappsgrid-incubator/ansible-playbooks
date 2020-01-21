#!/usr/bin/env bash

for digit in $@ ; do
	ip=10.1.1.$digit
	ssh-keygen -R $ip
	ssh-keyscan $ip >> ~/.ssh/known_hosts
done
