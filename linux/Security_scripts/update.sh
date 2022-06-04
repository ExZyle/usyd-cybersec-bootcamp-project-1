#!/usr/bin/env bash

apt update

# Get the daye on DDMMYYY format
DATE=``

date +'%d%m%Y'

mv /var/backup/home.tar /var/backup/home.`date +'%d%m%Y'`.tar