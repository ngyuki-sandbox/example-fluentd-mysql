#!/bin/bash

rsync -rci --rsync-path="sudo rsync" /vagrant/./files/  192.168.33.11:/etc/td-agent/
sudo /opt/td-agent/usr/sbin/td-agent
