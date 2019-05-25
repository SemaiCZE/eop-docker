#!/bin/bash

echo "Starting Docker daemon ..."
sudo systemctl start docker.service

echo "Allowing screen access for local connections ..."
xhost +local:

echo "Setting SELinux to permissive mode ..."
sudo setenforce 0

echo "Stopping pcscd daemon on host ..."
sudo systemctl stop pcscd.service

