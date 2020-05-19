sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python3.6

sudo apt install -y python3 python3.6-dev
wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
sudo python3.6 /tmp/get-pip.py

sudo apt install -y git nano screen wget zip unzip g++ htop software-properties-common pkg-config zlib1g-dev gdb cmake cmake-curses-gui autoconf gcc gcc-multilib g++-multilib libomp-dev libpq-dev


wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb


sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub

sudo apt update
sudo apt install cuda -y

CUDNN_VERSION="7.1"
CUDNN_TAR_FILE="cudnn-9.0-${CUDNN_VERSION}.tgz"
wget https://lia.epfl.ch/dependencies/${CUDNN_TAR_FILE} -O /tmp/${CUDNN_TAR_FILE}
tar -xzvf /tmp/${CUDNN_TAR_FILE}  -C /tmp/
sudo mkdir -p /usr/local/cuda-9.0/lib64

sudo cp -P /tmp/cuda/include/cudnn.h /usr/local/cuda-9.0/include
sudo cp -P /tmp/cuda/lib64/libcudnn* /usr/local/cuda-9.0/lib64/
sudo chmod a+r /usr/local/cuda-9.0/lib64/libcudnn*

/usr/bin/yes | pip3.6 install --upgrade pip
/usr/bin/yes | pip3.6 install cython cmake mkl mkl-include numpy pyyaml setuptools cffi typing mako pillow matplotlib mpmath pandas


git clone https://github.com/PKU-TANGENT/NeuralEDUSeg.git
cd NeuralEDUSeg
pip3 install -r requirements.txt
cd src


sudo python3.6 -m spacy download en_core_web_lg
python3.6 -m spacy link /usr/local/lib/python3.6/dist-packages/en_core_web_lg en

reboot
python3.6 run.py --evaluate --test_files ../data/rst/preprocessed/test/*.preprocessed
python3.6 run.py --segment --input_files ../../train/*.txt --result_dir ../../train_results/
