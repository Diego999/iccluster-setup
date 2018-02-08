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
VERSION="9.0"
SUB_VERSION="176"
SUB_SUB_VERSION="1"
CUDA_TAR_FILE="cuda-repo-ubuntu1604_${VERSION}.${SUB_VERSION}-${SUB_SUB_VERSION}_amd64.deb"
curl -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/${CUDA_TAR_FILE}
dpkg -i ./${CUDA_TAR_FILE}
apt-get update
apt-get --assume-yes install cuda=${VERSION}.${SUB_VERSION}-${SUB_SUB_VERSION} -y --allow-unauthenticated # Added this to make sure we don't drag down the newest version of cuda!
																										  # Some time the package is not signed with Nvidia GPG. --allow-unauthenticated is a workaround

# download and install libcudnn7, which is necessary tensorflow 1.5 GPU
CUDNN_TAR_FILE="cudnn-${VERSION}-linux-x64-v7.tgz" # Might not work if the token is not available anymore
wget http://developer2.download.nvidia.com/compute/machine-learning/cudnn/secure/v7.0.5/prod/9.0_20171129/${CUDNN_TAR_FILE}?tPwb9MaNc_aCvnkXenRXq25Amfy0o-E0eQngD5WQOPau6MUr9RcYrQRSzZc9RpF5V93kJr4FOnR7YT-AUVeQuzLYluRtJ-rVJYbKEGtrk_AreGM2ABpQmROr4PaoGvL0M70aY1wBu7u7MGnj473fXw8osiYYRs_KD7TOQKtpVjhFTNSHUAlVWJFkVx3By_OH-p8Yxp1h-04
tar -xzvf ${CUDNN_TAR_FILE}
mkdir /usr/local/cuda-${VERSION}
mkdir /usr/local/cuda-${VERSION}/lib64

# change to 9.0
sudo cp -P cuda/include/cudnn.h /usr/local/cuda-${VERSION}/include
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda-${VERSION}/lib64/
sudo chmod a+r /usr/local/cuda-${VERSION}/lib64/libcudnn*

# Add 128GB of swap
swapoff -a
dd if=/dev/zero of=/swapfile bs=1M count=131072
mkswap /swapfile
swapon /swapfile

# python3 as default
update-alternatives --install /usr/bin/python python /usr/bin/python3 2
update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 2

# install python packages for machine learning
yes | pip3 install --upgrade pip
yes | pip3 install pillow matplotlib mpmath jupyter pandas keras sklearn tensorflow-gpu spacy dill numpy configparser gensim pymysql stanford-corenlp pyrouge cython networkx
yes | pip3 install -U nltk==3.2.4
yes | pip3 install http://download.pytorch.org/whl/cu90/torch-0.3.0.post4-cp35-cp35m-linux_x86_64.whl 
yes | pip3 install torchvision

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
#cd data/WordNet-2.0-Exceptions/
#rm WordNet-2.0.exc.db # only if exist
#./buildExeptionDB.pl . exc WordNet-2.0.exc.db
#cd ../
#rm WordNet-2.0.exc.db # only if exist
#ln -s WordNet-2.0-Exceptions/WordNet-2.0.exc.db WordNet-2.0.exc.db

# clean up
cd /home
rm -r ./downloads

# Install dropbox
#cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
#~/.dropbox-dist/dropboxd

cd ~
echo "export DISPLAY=:0.0" >> .bashrc
