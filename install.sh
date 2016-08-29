#!/bin/bash

#install docker
sudo apt-get install -y curl
sudo curl -sSL http://get.docker.com | sudo sh
sudo usermod -aG docker $USER
sudo su root

#install compose
sudo curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > docker-compose
sudo mv docker-compose /usr/local/bin/
sudo chmod +x /usr/local/bin/docker-compose