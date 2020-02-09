#!/usr/bin/env bash

for ip in 149.165.169.179 149.165.156.140 ; do
	ssh-keygen -R $ip
	ssh-keyscan $ip >> ~/.ssh/known_hosts
done

