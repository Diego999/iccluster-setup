#!/bin/bash

# update repositories and upgrade packages
sudo apt update
sudo apt upgrade -y

export DEBIAN_FRONTEND=noninteractive

# install python
sudo apt install -y python3 python3-dev python3-distutils
wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
sudo python3.6 /tmp/get-pip.py

# install tools
sudo apt install -y git nano screen wget zip unzip g++ htop software-properties-common pkg-config zlib1g-dev gdb cmake cmake-curses-gui autoconf gcc gcc-multilib g++-multilib libomp-dev

# install chrome
# wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
# sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
# sudo apt update
# sudo apt install google-chrome-stable -y

# install java
# sudo add-apt-repository ppa:linuxuprising/java
# sudo apt update
# sudo apt install oracle-java11-installer -y
# sudo apt install oracle-java11-set-default -y

# Update mysql to 8.0
# wget https://repo.mysql.com//mysql-apt-config_0.8.12-1_all.deb -O /tmp/mysql.deb
# sudo dpkg -i /tmp/mysql.deb
# sudo apt update
# sudo apt install mysql-server -y

# echo "max_allowed_packet=2G" | sudo tee -a /etc/mysql/conf.d/mysql.cnf
# echo "" | sudo tee -a /etc/mysql/conf.d/mysql.cnf
# echo "[mysqld]" | sudo tee -a /etc/mysql/conf.d/mysql.cnf
# echo "innodb_buffer_pool_size=200G" | sudo tee -a /etc/mysql/conf.d/mysql.cnf

# download and install CUDA
VERSION="11.0"
SUB_VERSION="450"
SUB_SUB_VERSION="1"
CUDA_TAR_FILE="cuda-${VERSION}.${SUB_VERSION}-${SUB_SUB_VERSION}.deb"
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://lia.epfl.ch/dependencies/${CUDA_TAR_FILE} -O /tmp/${CUDA_TAR_FILE}
sudo dpkg -i /tmp/${CUDA_TAR_FILE}
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo apt update
sudo apt install cuda -y

# download and install libcudnn
CUDNN_VERSION="8.0"
CUDNN_TAR_FILE="cudnn-${VERSION}-${CUDNN_VERSION}.tgz"
wget https://lia.epfl.ch/dependencies/${CUDNN_TAR_FILE} -O /tmp/${CUDNN_TAR_FILE}
tar -xzvf /tmp/${CUDNN_TAR_FILE}  -C /tmp/
sudo mkdir -p /usr/local/cuda-${VERSION}/lib64

sudo cp -P /tmp/cuda/include/cudnn*.h /usr/local/cuda-${VERSION}/include
sudo cp -P /tmp/cuda/lib64/libcudnn* /usr/local/cuda-${VERSION}/lib64/
sudo chmod a+r /usr/local/cuda-${VERSION}/lib64/libcudnn*

# install python packages for machine learning
/usr/bin/yes | pip3.6 install --upgrade pip
/usr/bin/yes | pip3.6 install cython cmake mkl mkl-include numpy dill pyyaml setuptools cffi typing mako pillow matplotlib mpmath klepto
/usr/bin/yes | pip3.6 install jupyter pandas sklearn tensorflow keras spacy spacy_cld colored jupyterlab configparser gensim pymysql benepar
/usr/bin/yes | pip3.6 install selenium networkx bs4 fuzzywuzzy python-levenshtein pyldavis newspaper3k  wikipedia nltk py-rouge beautifultable tensor2tensor tensorboardX benepar

sudo python3.6 -m spacy download en_core_web_lg
sudo python3.6 -c "import nltk; nltk.download('punkt')"
sudo python3.6 -c "import nltk; nltk.download('stopwords')"
sudo python3.6 -c "import benepar; benepar.download('benepar_en2')"
sudo python3.6 -c "import benepar; benepar.download('benepar_en2_large')"

# pytorch
git clone --recursive https://github.com/pytorch/pytorch /tmp/pytorch
cd /tmp/pytorch
git checkout tags/v1.6.0
git submodule sync 
git submodule update --init --recursive
sudo python3.6 setup.py install
/usr/bin/yes | pip3.6 install torchvision

git clone https://github.com/epfml/sent2vec.git /tmp/sent2vec
cd /tmp/sent2vec
make
python3.6 setup.py install

git clone https://github.com/bheinzerling/pyrouge.git /tmp/pyrouge
cd /tmp/pyrouge
python3.6 setup.py install

git clone -b dev https://github.com/Diego999/sumy /tmp/sumy
cd /tmp/sumy
python3.6 setup.py install

git clone https://github.com/Diego999/text_histogram.git /tmp/text_histogram
cd /tmp/text_histogram
python3.6 setup.py install

git clone https://github.com/huggingface/neuralcoref.git /tmp/neuralcoref
cd /tmp/neuralcoref
python3.6 setup.py install

git clone https://github.com/neural-dialogue-metrics/Distinct-N.git /tmp/Distinct-N
cd /tmp/Distinct-N
python3.6 setup.py install

git clone https://github.com/Diego999/pyrouge.git /tmp/pyrouge
cd /tmp/pyrouge
python3.6 setup.py install

echo "export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}" | sudo tee -a /etc/environment
echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64/" | sudo tee -a /etc/environment
echo "export CPATH=/usr/local/cuda/include/${CPATH:+:${CPATH}}" | sudo tee -a /etc/environment

echo "export DISPLAY=:0.0" | sudo tee -a /etc/environment 
echo "export MYSQL_USER='root'" | sudo tee -a /etc/environment
echo "export MYSQL_PASSWORD=''" | sudo tee -a /etc/environment
echo "export OMP_NUM_THREADS='1'" | sudo tee -a /etc/environment

source /etc/environment

echo "* hard nofile 64000" | sudo tee -a /etc/security/limits.conf 

echo "vm.swappiness=1" | sudo tee -a /etc/sysctl.conf

# Launch config of CPAN to install XML::Parser for pyrouge
#cpan
#install XML::Parser
#install XML::DOM
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

sudo chmod -x /etc/update-motd.d/*

sudo reboot

