#!/bin/bash

# update repositories and upgrade packages
apt-get update
apt-get --assume-yes upgrade
apt-get update
apt-get --assume-yes upgrade

# install python and tools
apt-get --assume-yes install python3 python3-dev python3-pip
apt-get --assume-yes install git nano screen wget zip unzip g++ htop software-properties-common pkg-config zlib1g-dev
apt-get --assume-yes install -y gdb cmake cmake-curses-gui autoconf gcc gcc-multilib g++-multilib 

mkdir /home/downloads
cd /home/downloads

# # download and install CUDA
# sudo apt-get install cuda-8.0

curl -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb # cuda-repo-ubuntu1604_9.1.85-1_amd64.deb
dpkg -i ./cuda-repo-ubuntu1604_8.0.61-1_amd64.deb # cuda-repo-ubuntu1604_9.1.85-1_amd64.deb
apt-get update
#  Added this to make sure we don't drag down the newest version of cuda!
apt-get install cuda=8.0.61-1 -y # just cuda

# download and install libcudnn6, which is necessary tensorflow 1.4 GPU
CUDNN_TAR_FILE="cudnn-8.0-linux-x64-v6.0.tgz" # https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.0.5/prod/9.1_20171129/cudnn-9.1-linux-x64-v7
wget http://developer.download.nvidia.com/compute/redist/cudnn/v6.0/${CUDNN_TAR_FILE}
tar -xzvf ${CUDNN_TAR_FILE}
mkdir /usr/local/cuda-8.0
mkdir /usr/local/cuda-8.0/lib64

# change to 9.1
sudo cp -P cuda/include/cudnn.h /usr/local/cuda-8.0/include
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda-8.0/lib64/
sudo chmod a+r /usr/local/cuda-8.0/lib64/libcudnn*

# python3 as default
update-alternatives --install /usr/bin/python python /usr/bin/python3 2
update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 2


# install python packages for machine learning
yes | pip3 install --upgrade pip
yes | pip3 install pillow matplotlib mpmath jupyter pandas keras sklearn tensorflow tensorflow-gpu spacy dill numpy configparser gensim pymysql stanford-corenlp
yes | pip3 install -U nltk


git clone https://github.com/mpagli/stanford_corenlp_pywrapper
cd stanford_corenlp_pywrapper
yes | pip install .

# clean up
cd /home
rm -r ./downloads

# Install dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd

cd ~
echo "export DISPLAY=:0.0" >> .bashrc
