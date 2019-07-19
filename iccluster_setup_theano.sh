#!/bin/bash

# WORKS FOR UBUNTU 14.04

# update repositories and upgrade packages
sudo apt update
sudo apt upgrade -y

export DEBIAN_FRONTEND=noninteractive

sudo apt install -y python3 python3-dev python3-distutils
wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
sudo python3 /tmp/get-pip.py

sudo apt install -y git nano screen wget zip unzip g++ htop software-properties-common pkg-config zlib1g-dev gdb cmake cmake-curses-gui autoconf gcc gcc-multilib g++-multilib


wget http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda-repo-ubuntu1404-7-5-local_7.5-18_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo dpkg -i cuda-repo-ubuntu1404-7-5-local_7.5-18_amd64.deb
sudo apt update
sudo apt install cuda=7.5-18 -y

# Download Cudnn 5.1
# wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v5.1/prod_20161129/7.5/cudnn-7.5-linux-x64-v5.1-tgz
tar -xzvf cudnn-7.5-linux-x64-v5.1.tgz
sudo mkdir -p /usr/local/cuda-7.5/lib64

sudo cp -P cuda/include/cudnn.h /usr/local/cuda-7.5/include
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda-7.5/lib64/
sudo chmod a+r /usr/local/cuda-7.5/lib64/libcudnn*


sudo apt install -y python-numpy python-scipy python-dev python-pip python-nose g++ libblas-dev git
sudo apt install -y python3-numpy python3-scipy python3-dev python3-pip python3-nose g++ libopenblas-dev git

wget https://github.com/Theano/Theano/archive/rel-0.8.2.zip
unzip rel-0.8.2.zip
cd Theano-rel-0.8.2
pip3 install .
pip2 install .

echo "export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}" | sudo tee -a /etc/environment
echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64/" | sudo tee -a /etc/environment
echo "export CPATH=/usr/local/cuda/include/${CPATH:+:${CPATH}}" | sudo tee -a /etc/environment
source /etc/environment
