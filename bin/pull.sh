#!/usr/bin/env bash

# Use rsync to transfer files since most hosts will not have git installed (and we don't want git installed).
rsync -azvhe ssh ubuntu@129.114.17.81:/home/ubuntu/ansible ../
