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

VERSION="9.0"
SUB_VERSION="176.1"
CUDA_TAR_FILE="cuda-repo-ubuntu1604_${VERSION}.${SUB_VERSION}_amd64.deb"
curl -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/${CUDA_TAR_FILE}
dpkg -i ./${CUDA_TAR_FILE}
apt-get update
#  Added this to make sure we don't drag down the newest version of cuda!
apt-get --assume-yes install cuda=${VERSION}.${SUB_VERSION} -y

# download and install libcudnn7, which is necessary tensorflow 1.5 GPU
CUDNN_TAR_FILE="cudnn-${VERSION}-linux-x64-v7.tgz" # Temporary fix
wget http://developer2.download.nvidia.com/compute/machine-learning/cudnn/secure/v7.0.5/prod/9.0_20171129/${CUDNN_TAR_FILE}?tPwb9MaNc_aCvnkXenRXq25Amfy0o-E0eQngD5WQOPau6MUr9RcYrQRSzZc9RpF5V93kJr4FOnR7YT-AUVeQuzLYluRtJ-rVJYbKEGtrk_AreGM2ABpQmROr4PaoGvL0M70aY1wBu7u7MGnj473fXw8osiYYRs_KD7TOQKtpVjhFTNSHUAlVWJFkVx3By_OH-p8Yxp1h-04
tar -xzvf ${CUDNN_TAR_FILE}
mkdir /usr/local/cuda-${VERSION}
mkdir /usr/local/cuda-${VERSION}/lib64

# change to 9.1
sudo cp -P cuda/include/cudnn.h /usr/local/cuda-${VERSION}/include
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda-${VERSION}/lib64/
sudo chmod a+r /usr/local/cuda-${VERSION}/lib64/libcudnn*

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
