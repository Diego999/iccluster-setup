#!/bin/bash

# update repositories and upgrade packages
apt-get update
apt-get --assume-yes upgrade
apt-get update
apt-get --assume-yes upgrade

# install python and tools
apt-get --assume-yes install git nano screen wget zip unzip g++ htop python3 python3-dev python3-pip python3-tk software-properties-common pkg-config zlib1g-dev
apt-get --assume-yes install -y gdb cmake cmake-curses-gui autoconf gcc gcc-multilib g++-multilib 
apt-get --assume-yes install -y python-pip python-dev python-setuptools build-essential python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose python3 python3-pip python3-dev python-wheel python3-wheel python-boto python3-pandas python3-sympy python3-nose python3-matplotlib python3-scipy python3-numpy python3-setuptools

mkdir /home/downloads
cd /home/downloads

# download and install CUDA
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
apt-get update
apt-get --assume-yes install cuda

# download and install libcudnn5, which is necessary, for example, for Conv2D layers
ML_REPO_PKG=http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/nvidia-machine-learning-repo-ubuntu1604_1.0.0-1_amd64.deb
wget "$ML_REPO_PKG" -O /tmp/ml-repo.deb && sudo dpkg -i /tmp/ml-repo.deb && rm -f /tmp/ml-repo.deb
apt-get update
apt-get --assume-yes install libcudnn5

# bazel
## JAVA
add-apt-repository ppa:webupd8team/java -y
apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
apt-get install -y oracle-java8-installer
## Next
wget -P /tmp https://github.com/bazelbuild/bazel/releases/download/0.4.5/bazel-0.4.5-installer-linux-x86_64.sh
chmod +x /tmp/bazel-0.4.1-installer-linux-x86_64.sh
/tmp/bazel-0.4.1-installer-linux-x86_64.sh 

# python3 as default
update-alternatives --install /usr/bin/python python /usr/bin/python3 2
update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 2

#########################################
# Python packages using pip

pip install --upgrade pip

# ipython in apt-get is outdated
pip install ipython --upgrade 

########################################
# NLTK
pip install -U nltk

# install python packages for machine learning
yes | pip install keras sklearn pillow matplotlib spacy pycorenlp dill pandas numpy configparser

if [ "$1" = "cpu" ]; then
	yes | pip install tensorflow
else
	yes | pip install tensorflow-gpu
fi

git clone https://github.com/mpagli/stanford_corenlp_pywrapper
cd stanford_corenlp_pywrapper
yes | pip install .

# clean up
cd /home
rm -r ./downloads

cd ~
echo "export DISPLAY=:0.0" >> .bashrc
