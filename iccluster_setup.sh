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
VERSION="9.1"
SUB_VERSION="85"
SUB_SUB_VERSION="1"
CUDA_TAR_FILE="cuda-repo-ubuntu1604_${VERSION}.${SUB_VERSION}-${SUB_SUB_VERSION}_amd64.deb"
curl -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/${CUDA_TAR_FILE}
apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
dpkg -i ./${CUDA_TAR_FILE}
apt-get update
apt-get --assume-yes install cuda=${VERSION}.${SUB_VERSION}-${SUB_SUB_VERSION}

# download and install libcudnn
CUDNN_TAR_FILE="cudnn-${VERSION}-linux-x64-v7.1.tgz" # Might not work if the token is not available anymore
wget http://developer2.download.nvidia.com/compute/machine-learning/cudnn/secure/v7.0.5/prod/9.1_20171129/cudnn-9.1-linux-x64-v7.tgz?r0qEHvZ83SnZOvAHNo_H_W05_JexekixSLgWKktpfAJQxzOcJ-Mn8aBhKTaxSMijUfMOdzeZECmzc5FHeL8Dwbht6jl23v7a_gw9ysX1fJuR6fkOSKYDdxXqJRe4GUdTDVHw_YYqawd50rSih-lNUHhjuNJh8guKisrmxLy92UxUMyP6PYGLre0vCEqtRBCiPCq2JQnEla4
tar -xzvf ${CUDNN_TAR_FILE}
mkdir /usr/local/cuda-${VERSION}
mkdir /usr/local/cuda-${VERSION}/lib64

# change to 9.1
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
yes | pip3 install pillow matplotlib mpmath jupyter pandas keras sklearn spacy dill numpy configparser gensim pymysql stanford-corenlp cython networkx
yes | pip3 install -U nltk==3.2.4

#yes | pip3 install http://download.pytorch.org/whl/cu91/torch-0.3.1-cp35-cp35m-linux_x86_64.whl

# or 
git clone --recursive https://github.com/pytorch/pytorch 
cd pytorch
git checkout 2b2d56d8460d335daf5aa79774442a111d424f90
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

# Launch config of CPAN to install XML::Parser for pyrouge
#cpan
#install XML::Parser
#exit

# Fix if bug with wordnet
cd data/WordNet-2.0-Exceptions/
rm WordNet-2.0.exc.db # only if exist
./buildExeptionDB.pl . exc WordNet-2.0.exc.db
cd ../
rm WordNet-2.0.exc.db # only if exist
ln -s WordNet-2.0-Exceptions/WordNet-2.0.exc.db WordNet-2.0.exc.db

# clean up
cd /home
rm -r ./downloads

# Install dropbox
#cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
#~/.dropbox-dist/dropboxd

cd ~
echo "export DISPLAY=:0.0" >> .bashrc
