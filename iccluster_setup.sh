#!/bin/bash

# update repositories and upgrade packages
apt-get update
apt-get --assume-yes upgrade
apt-get update
apt-get --assume-yes upgrade

# install python and tools
apt-get --assume-yes install python3 python3-dev python3-pip python3-yaml git nano screen wget zip unzip g++ htop software-properties-common pkg-config zlib1g-dev gdb cmake cmake-curses-gui autoconf gcc gcc-multilib g++-multilib mysql-server 

mkdir /home/downloads
cd /home/downloads

# download and install CUDA
VERSION="10.0"
SUB_VERSION="130"
SUB_SUB_VERSION="1"
CUDA_TAR_FILE="cuda-${VERSION}.${SUB_VERSION}-${SUB_SUB_VERSION}.deb"
wget http://lia.epfl.ch/dependencies/${CUDA_TAR_FILE}
apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
dpkg -i ./${CUDA_TAR_FILE}
apt-get update
apt-get --assume-yes install cuda=${VERSION}.${SUB_VERSION}-${SUB_SUB_VERSION}

# download and install libcudnn
CUDNN_VERSION="7.3"
CUDNN_TAR_FILE="cudnn-${VERSION}-${CUDNN_VERSION}.tgz"
wget http://lia.epfl.ch/dependencies/${CUDNN_TAR_FILE}
tar -xzvf ${CUDNN_TAR_FILE}
mkdir /usr/local/cuda-${VERSION}
mkdir /usr/local/cuda-${VERSION}/lib64

cp -P cuda/include/cudnn.h /usr/local/cuda-${VERSION}/include
cp -P cuda/lib64/libcudnn* /usr/local/cuda-${VERSION}/lib64/
chmod a+r /usr/local/cuda-${VERSION}/lib64/libcudnn*

# install python packages for machine learning
yes | pip3 install --upgrade pip
yes | pip3 install pillow matplotlib mpmath jupyter pandas sklearn tensorflow spacy dill numpy configparser gensim pymysql stanford-corenlp cython networkx bs4 mako fuzzywuzzy langdetect python-levenshtein pyldavis newspaper3k wikipedia nltk py-rouge pyrouge beautifultable tensor2tensor tensorboardX
pip3 install https://github.com/explosion/spacy-models/releases/download/en_core_web_lg-2.0.0/en_core_web_lg-2.0.0.tar.gz
python3 -c "import nltk; nltk.download('punkt')"

# If we need tensorflow with python3.7
# the wheel is here: http://lia.epfl.ch/dependencies/tensorflow-1.11.0rc1-cp37-cp37m-linux_x86_64.whl

# If pip is broken afterwrads
'
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --force-reinstall
'

# 
'
git clone --recursive https://github.com/pytorch/pytorch 
cd pytorch
git checkout 2b2d56d8460d335daf5aa79774442a111d424f90
git submodule update --init
git submodule update --recursive
python3 setup.py install
'

# or
git clone --recursive https://github.com/pytorch/pytorch 
cd pytorch
git checkout tags/v1.0rc1
git submodule update --init
git submodule update --recursive
python3 setup.py install

yes | pip3 install torchvision

git clone https://github.com/epfml/sent2vec.git
cd sent2vec
make
cd src
python3 setup.py build_ext
pip3 install .

git clone -b dev https://github.com/Diego999/sumy
cd sumy
python3 setup.py install

git clone https://github.com/Diego999/text_histogram.git
cd text_histogram
python3 setup.py install

jupyter notebook --allow-root --generate-config
echo "c.NotebookApp.ip = '*'" >> /root/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py

echo "export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}" >> ~/.profile
echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64/" >> ~/.profile
echo "export CPATH=/usr/local/cuda/include/${CPATH:+:${CPATH}}" >> ~/.profile 
source ~/.profile

cd ~
echo "export DISPLAY=:0.0" >> ~/.bashrc
echo "export MYSQL_USER='root'" >> ~/.bashrc
echo "export MYSQL_PASSWORD=''" >> ~/.bashrc
echo "export OMP_NUM_THREADS='1'" >> ~/.bashrc
echo "ulimit -n 64000" >> .bashrc

echo "export DISPLAY=:0.0" >> ~/.profile
echo "export MYSQL_USER='root'" >> ~/.profile
echo "export MYSQL_PASSWORD=''" >> ~/.profile
echo "export OMP_NUM_THREADS='1'" >> ~/.profile
echo "ulimit -n 64000" >> .profile

source ~/.bashrc
source ~/.profile

echo "vm.swappiness=1" >> /etc/sysctl.conf

# Launch config of CPAN to install XML::Parser for pyrouge
#cpan
#install XML::Parser
#exit

# Fix if bug with wordnet
'
cd data/WordNet-2.0-Exceptions/
rm WordNet-2.0.exc.db # only if exist
./buildExeptionDB.pl . exc WordNet-2.0.exc.db
cd ../
rm WordNet-2.0.exc.db # only if exist
ln -s WordNet-2.0-Exceptions/WordNet-2.0.exc.db WordNet-2.0.exc.db
'

# clean up
cd /home
rm -r ./downloads

# Install dropbox
#cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
#~/.dropbox-dist/dropboxd

'
# If we let the default password
sudo mysql -u root # I had to use "sudo" since is new installation

USE mysql;
UPDATE user SET plugin='mysql_native_password' WHERE User='root';
FLUSH PRIVILEGES;
exit;

service mysql restart
'

