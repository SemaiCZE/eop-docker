#!/bin/bash

echo "Starting pcscd daemon on host ..."
sudo systemctl start pcscd.service

echo "Setting SELinux to enforcing mode ..."
sudo setenforce 1

echo "Disallowing screen access for local connections ..."
xhost -local:

echo "Stopping Docker daemon ..."
sudo systemctl stop docker.service

