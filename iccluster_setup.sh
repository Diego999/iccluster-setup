#!/bin/bash

# update repositories and upgrade packages
apt-get update
apt-get --assume-yes upgrade
apt-get update
apt-get --assume-yes upgrade

# install python and tools
apt-get --assume-yes install python3 python3-dev python3-pip python3-yaml git nano screen wget zip unzip g++ htop software-properties-common pkg-config zlib1g-dev gdb cmake cmake-curses-gui autoconf gcc gcc-multilib g++-multilib 

mkdir /home/downloads
cd /home/downloads

# # download and install CUDA
VERSION="9.2"
SUB_VERSION="148"
SUB_SUB_VERSION="1"
CUDA_TAR_FILE="cuda-repo-ubuntu1604_${VERSION}.${SUB_VERSION}-${SUB_SUB_VERSION}_amd64.deb"
curl -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/${CUDA_TAR_FILE}
apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
dpkg -i ./${CUDA_TAR_FILE}
apt-get update
apt-get --assume-yes install cuda=${VERSION}.${SUB_VERSION}-${SUB_SUB_VERSION}

# download and install libcudnn
CUDNN_VERSION="7.1"
CUDNN_TAR_FILE="cudnn-${VERSION}-linux-x64-v${CUDNN_VERSION}.tgz"
wget https://www.dropbox.com/s/jxu34x4tyveic20/${CUDNN_TAR_FILE}
tar -xzvf ${CUDNN_TAR_FILE}
mkdir /usr/local/cuda-${VERSION}
mkdir /usr/local/cuda-${VERSION}/lib64
	
sudo cp -P cuda/include/cudnn.h /usr/local/cuda-${VERSION}/include
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda-${VERSION}/lib64/
sudo chmod a+r /usr/local/cuda-${VERSION}/lib64/libcudnn*

# Add 128GB of swap
#swapoff -a
#dd if=/dev/zero of=/swapfile bs=1M count=131072
#mkswap /swapfile
#swapon /swapfile

# install python packages for machine learning
yes | pip3 install --upgrade pip
yes | pip3 install pillow matplotlib mpmath jupyter pandas keras tensorflow-gpu sklearn spacy dill numpy configparser gensim pymysql stanford-corenlp cython networkx beautifulsoup4 mako fuzzywuzzy langdetect python-levenshtein pyldavis
yes | pip3 install -U nltk==3.2.4

#yes | pip3 install http://download.pytorch.org/whl/cu91/torch-0.3.1-cp35-cp35m-linux_x86_64.whl

# or 
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
git checkout tags/v0.4.1
git submodule update --init
git submodule update --recursive
python3 setup.py install


yes | pip3 install torchvision

git clone https://github.com/Diego999/pyrouge
cd pyrouge
python3 setup.py install

git clone https://github.com/epfml/sent2vec.git
cd sent2vec
make
cd src
python3 setup.py build_ext
pip3 install .

git clone https://github.com/Diego999/sumy
cd sumy
python3 setup.py install

'
jupyter notebook --allow-root --generate-config
echo "c.NotebookApp.ip = '*'" >> /root/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py

echo "export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}" >> ~/.profile
echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64/" >> ~/.profile
echo "export CPATH=/usr/local/cuda/include/${CPATH:+:${CPATH}}" >> ~/.profile 
source ~/.profile
'

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

cd ~
echo "export DISPLAY=:0.0" >> .bashrc
