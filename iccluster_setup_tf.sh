#!/bin/bash

# update repositories and upgrade packages
apt-get update
apt-get upgrade -y

export DEBIAN_FRONTEND=noninteractive
# install python and tools
apt-get install python3 python3-dev python3-pip python3-yaml git nano screen wget zip unzip g++ htop software-properties-common pkg-config zlib1g-dev gdb cmake cmake-curses-gui autoconf gcc gcc-multilib g++-multilib -y

sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" | sudo tee /etc/apt/sources.list.d/cuda.list

sudo apt-get update 
sudo apt-get -o Dpkg::Options::="--force-overwrite" install cuda-10-0 cuda-drivers -y

echo "export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc
source ~/.bashrc
sudo ldconfig

# download and install libcudnn
CUDNN_TAR_FILE="cudnn-10.0-7.4.tgz"
wget https://lia.epfl.ch/dependencies/${CUDNN_TAR_FILE} -O /tmp/${CUDNN_TAR_FILE}
tar -xzvf /tmp/${CUDNN_TAR_FILE}  -C /tmp/
mkdir -p /usr/local/cuda-10/lib64

cp -P /tmp/cuda/include/cudnn.h /usr/local/cuda-10.0/include
cp -P /tmp/cuda/lib64/libcudnn* /usr/local/cuda-10.0/lib64/
chmod a+r /usr/local/cuda-10/lib64/libcudnn*

/usr/bin/yes | pip3 install --upgrade pip
/usr/bin/yes | pip3 install tensorboard==1.14.0
/usr/bin/yes | pip3 install tensorflow-estimator==1.14.0
/usr/bin/yes | pip3 install tensorflow-gpu==1.14.0
/usr/bin/yes | pip3 install tqdm pillow matplotlib mpmath jupyter pandas sklearn numpy configparser cython nltk py-rouge pyrouge sty tqdm colored
/usr/bin/yes | pip3 install torch==1.4.0
/usr/bin/yes | pip3 install torchtext

echo "export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}" >> /etc/environment
echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64/" >> /etc/environment
echo "export CPATH=/usr/local/cuda/include/${CPATH:+:${CPATH}}" >> /etc/environment

echo "export DISPLAY=:0.0" >> /etc/environment 
echo "export MYSQL_USER='root'" >> /etc/environment
echo "export MYSQL_PASSWORD=''" >> /etc/environment
echo "export OMP_NUM_THREADS='1'" >> /etc/environment

echo "* hard nofile 64000" >> /etc/security/limits.conf 

echo "vm.swappiness=1" >> /etc/sysctl.conf
source /etc/environment

mkdir /mnt/t1
mount /dev/sdb /mnt/t1

mkdir /mnt/t2
mount /dev/sdc /mnt/t2

mkdir /mnt/t3
mount /dev/sdd /mnt/t3

mkdir /mnt/t4
mount /dev/sde /mnt/t4

mkdir /mnt/t5
mount /dev/sdf /mnt/t5

mkdir /mnt/t6
mount /dev/sdg /mnt/t6

reboot

