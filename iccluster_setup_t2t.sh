#!/bin/bash

# update repositories and upgrade packages
apt-get update
apt-get upgrade -y

#MySQL ask for password 
export DEBIAN_FRONTEND=noninteractive
# or provide a fake password
#sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password your_password'
#sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password your_password'

# install python and tools
apt-get install python3 python3-dev python3-pip python3-yaml git nano screen wget zip unzip g++ htop software-properties-common pkg-config zlib1g-dev gdb cmake cmake-curses-gui autoconf gcc gcc-multilib g++-multilib -y

# download and install CUDA
VERSION="9.0"
SUB_VERSION="176"
SUB_SUB_VERSION="1"
CUDA_TAR_FILE="cuda-${VERSION}.${SUB_VERSION}-${SUB_SUB_VERSION}.deb"
#HTTP request sent, awaiting response... 302 Found
#Location: https://lia.epfl.ch/dependencies/...
wget https://lia.epfl.ch/dependencies/${CUDA_TAR_FILE} -O /tmp/${CUDA_TAR_FILE}
apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
dpkg -i /tmp/${CUDA_TAR_FILE}
apt-get update
apt-get install cuda=${VERSION}.${SUB_VERSION}-${SUB_SUB_VERSION} -y

# download and install libcudnn
CUDNN_VERSION="7.3"
CUDNN_TAR_FILE="cudnn-${VERSION}-${CUDNN_VERSION}.tgz"
wget https://lia.epfl.ch/dependencies/${CUDNN_TAR_FILE} -O /tmp/${CUDNN_TAR_FILE}
tar -xzvf /tmp/${CUDNN_TAR_FILE}  -C /tmp/
mkdir -p /usr/local/cuda-${VERSION}/lib64

cp -P /tmp/cuda/include/cudnn.h /usr/local/cuda-${VERSION}/include
cp -P /tmp/cuda/lib64/libcudnn* /usr/local/cuda-${VERSION}/lib64/
chmod a+r /usr/local/cuda-${VERSION}/lib64/libcudnn*

/usr/bin/yes | pip3 install --upgrade pip
/usr/bin/yes | pip3 install tensor2tensor[tensorflow_gpu]
/usr/bin/yes | pip3 install pillow matplotlib mpmath jupyter pandas sklearn numpy configparser cython nltk py-rouge pyrouge

echo "export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}" >> /etc/environment
echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64/" >> /etc/environment
echo "export CPATH=/usr/local/cuda/include/${CPATH:+:${CPATH}}" >> /etc/environment

echo "export DISPLAY=:0.0" >> /etc/environment 
echo "export MYSQL_USER='root'" >> /etc/environment
echo "export MYSQL_PASSWORD=''" >> /etc/environment
echo "export OMP_NUM_THREADS='1'" >> /etc/environment
source /etc/environment

echo "* hard nofile 64000" >> /etc/security/limits.conf 

echo "vm.swappiness=1" >> /etc/sysctl.conf

# Launch config of CPAN to install XML::Parser for pyrouge
#cpan
#install XML::Parser
#exit

# Fix if bug with wordnet
#cd data/WordNet-2.0-Exceptions/
#rm WordNet-2.0.exc.db # only if exist
#./buildExeptionDB.pl . exc WordNet-2.0.exc.db
#cd ../
#rm WordNet-2.0.exc.db # only if exist
#ln -s WordNet-2.0-Exceptions/WordNet-2.0.exc.db WordNet-2.0.exc.db