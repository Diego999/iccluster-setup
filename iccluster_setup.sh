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
apt-get install python3 python3-dev python3-pip python3-yaml git nano screen wget zip unzip g++ htop software-properties-common pkg-config zlib1g-dev gdb cmake cmake-curses-gui autoconf gcc gcc-multilib g++-multilib mysql-server -y

# install java
#add-apt-repository ppa:webupd8team/java
#apt update
#apt install oracle-java8-installer -y

# download and install CUDA
VERSION="10.1"
SUB_VERSION="105"
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
CUDNN_VERSION="7.5"
CUDNN_TAR_FILE="cudnn-${VERSION}-${CUDNN_VERSION}.tgz"
wget https://lia.epfl.ch/dependencies/${CUDNN_TAR_FILE} -O /tmp/${CUDNN_TAR_FILE}
tar -xzvf /tmp/${CUDNN_TAR_FILE}  -C /tmp/
mkdir -p /usr/local/cuda-${VERSION}/lib64

cp -P /tmp/cuda/include/cudnn.h /usr/local/cuda-${VERSION}/include
cp -P /tmp/cuda/lib64/libcudnn* /usr/local/cuda-${VERSION}/lib64/
chmod a+r /usr/local/cuda-${VERSION}/lib64/libcudnn*

# install python packages for machine learning
/usr/bin/yes | pip3 install --upgrade pip
/usr/bin/yes | pip3 install pillow matplotlib mpmath jupyter pandas sklearn tensorflow spacy dill numpy configparser gensim pymysql stanford-corenlp cython networkx bs4 mako fuzzywuzzy langdetect python-levenshtein pyldavis newspaper3k wikipedia nltk py-rouge pyrouge beautifultable tensor2tensor tensorboardX
python3 -m spacy download en_core_web_lg
python3 -c "import nltk; nltk.download('punkt')"

# If we need tensorflow with python3.7
# the wheel is here: http://lia.epfl.ch/dependencies/tensorflow-1.11.0rc1-cp37-cp37m-linux_x86_64.whl

# If pip is broken afterwrads
#curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
#python3 get-pip.py --force-reinstall

# pytorch
git clone --recursive https://github.com/pytorch/pytorch /tmp/pytorch
cd /tmp/pytorch
git checkout tags/v1.0.1
git submodule update --init
git submodule update --recursive
python3 setup.py install
/usr/bin/yes | pip3 install torchvision

git clone https://github.com/epfml/sent2vec.git /tmp/sent2vec
cd /tmp/sent2vec
make
python3 setup.py install

git clone -b dev https://github.com/Diego999/sumy /tmp/sumy
cd /tmp/sumy
python3 setup.py install

git clone https://github.com/Diego999/text_histogram.git /tmp/text_histogram
cd /tmp/text_histogram
python3 setup.py install

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

# Install dropbox
#cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
#~/.dropbox-dist/dropboxd
mysql -u root -D mysql -e "UPDATE user SET plugin='mysql_native_password' WHERE User='root'"
mysql -u root -D mysql -e "FLUSH PRIVILEGES;"

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
