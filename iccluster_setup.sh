#!/bin/bash

# update repositories and upgrade packages
sudo apt update
sudo apt upgrade -y

export DEBIAN_FRONTEND=noninteractive

# install python
sudo apt install -y python3.7 python3.7-dev python3.7-distutils
wget https://bootstrap.pypa.io/get-pip.py
python3.7 get-pip.py
rm get-pip.py

# install tools
sudo apt install -y git nano screen wget zip unzip g++ htop software-properties-common pkg-config zlib1g-dev gdb cmake cmake-curses-gui autoconf gcc gcc-multilib g++-multilib

# install chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update
sudo apt install google-chrome-stable -y

# install java
sudo add-apt-repository ppa:webupd8team/java
sudo apt update
sudo apt install oracle-java8-installer -y

# Update mysql to 8.0
wget https://repo.mysql.com//mysql-apt-config_0.8.12-1_all.deb -O /tmp/mysql.deb
sudo dpkg -i /tmp/mysql.deb
sudo apt update
sudo apt install mysql-server -y

sudo echo "max_allowed_packet=2G" >>  /etc/mysql/conf.d/mysql.cnf
sudo echo "" >> /etc/mysql/conf.d/mysql.cnf
sudo echo "[mysqld]" >>  /etc/mysql/conf.d/mysql.cnf
sudo echo "innodb_buffer_pool_size=200G" >>  /etc/mysql/conf.d/mysql.cnf

# download and install CUDA
VERSION="10.1"
SUB_VERSION="105"
SUB_SUB_VERSION="1"
CUDA_TAR_FILE="cuda-${VERSION}.${SUB_VERSION}-${SUB_SUB_VERSION}.deb"
wget https://lia.epfl.ch/dependencies/${CUDA_TAR_FILE} -O /tmp/${CUDA_TAR_FILE}
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo dpkg -i /tmp/${CUDA_TAR_FILE}
sudo apt update
sudo apt install cuda=${VERSION}.${SUB_VERSION}-${SUB_SUB_VERSION} -y

# download and install libcudnn
CUDNN_VERSION="7.5"
CUDNN_TAR_FILE="cudnn-${VERSION}-${CUDNN_VERSION}.tgz"
wget https://lia.epfl.ch/dependencies/${CUDNN_TAR_FILE} -O /tmp/${CUDNN_TAR_FILE}
tar -xzvf /tmp/${CUDNN_TAR_FILE}  -C /tmp/
sudo mkdir -p /usr/local/cuda-${VERSION}/lib64

sudo cp -P /tmp/cuda/include/cudnn.h /usr/local/cuda-${VERSION}/include
sudo cp -P /tmp/cuda/lib64/libcudnn* /usr/local/cuda-${VERSION}/lib64/
sudo chmod a+r /usr/local/cuda-${VERSION}/lib64/libcudnn*

# install python packages for machine learning
/usr/bin/yes | pip3.7 install --upgrade pip
/usr/bin/yes | pip3.7 install pillow matplotlib mpmath jupyter pandas sklearn tensorflow spacy spacy_cld dill numpy configparser gensim pymysql selenium cython networkx bs4 mako fuzzywuzzy python-levenshtein pyldavis newspaper3k wikipedia nltk py-rouge pyrouge beautifultable tensor2tensor tensorboardX
python3.7 -m spacy download en_core_web_lg
python3.7 -c "import nltk; nltk.download('punkt')"

# pytorch
git clone --recursive https://github.com/pytorch/pytorch /tmp/pytorch
cd /tmp/pytorch
git checkout tags/v1.1.0
git submodule update --init
git submodule update --recursive
python3.7 setup.py install
/usr/bin/yes | pip3.7 install torchvision

# git clone https://github.com/epfml/sent2vec.git /tmp/sent2vec
# cd /tmp/sent2vec
# make
# python3.7 setup.py install

# git clone -b dev https://github.com/Diego999/sumy /tmp/sumy
# cd /tmp/sumy
# python3.7 setup.py install

# git clone https://github.com/Diego999/text_histogram.git /tmp/text_histogram
# cd /tmp/text_histogram
# python3.7 setup.py install

sudo echo "export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}" >> /etc/environment
sudo echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64/" >> /etc/environment
sudo echo "export CPATH=/usr/local/cuda/include/${CPATH:+:${CPATH}}" >> /etc/environment

sudo echo "export DISPLAY=:0.0" >> /etc/environment 
sudo echo "export MYSQL_USER='root'" >> /etc/environment
sudo echo "export MYSQL_PASSWORD=''" >> /etc/environment
sudo echo "export OMP_NUM_THREADS='1'" >> /etc/environment

source /etc/environment

sudo echo "* hard nofile 64000" >> /etc/security/limits.conf 

sudo echo "vm.swappiness=1" >> /etc/sysctl.conf

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

sudo mkdir /mnt/t1
sudo mount /dev/sdb /mnt/t1

sudo mkdir /mnt/t2
sudo mount /dev/sdc /mnt/t2
