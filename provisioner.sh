#! /bin/bash

set -m

echo "Setting environment variable"

echo $SL_USERNAME
echo $SL_API_KEY
echo $ANSIBLE_INVENTORY_FILE
echo $PRIVATEKEY
echo $PUBLICKEY
echo $ANSIBLE_HOST_KEY_CHECKING
echo $PACKER_LOG
echo $PACKER_LOG_PATH
echo $OBJC_DISABLE_INITIALIZE_FORK_SAFETY


# Using https://github.com/canha/golang-tools-install-script
# Linux typically has wget installed
wget -q -O - https://raw.githubusercontent.com/canha/golang-tools-install-script/master/goinstall.sh | bash

# # macOS typically has curl installed
# curl https://raw.githubusercontent.com/canha/golang-tools-install-script/master/goinstall.sh | bash

# Set Go Path
mkdir go
export GOPATH=$HOME/go
mkdir $GOPATH/src/github.com


# Download and Install packer
apt-get install unzip -y
wget -q -O -  https://raw.github.com/robertpeteuil/packer-installer/master/packer-install.sh | bash


# Export path as Packer Path
export PATH=$PATH:/usr/local/bin/packer

# Use the script from Step 2: https://github.com/IBM/packer-plugin-ibmcloud
apt-get install git -y
go get github.com/hashicorp/packer
cd $GOPATH/src/github.com/hashicorp/packer/vendor
rm -r golang.org
mkdir -p $GOPATH/src/golang.org/x/
cd $GOPATH/src/golang.org/x/
git clone https://github.com/golang/crypto.git
git clone https://github.com/golang/oauth2.git
git clone https://github.com/golang/net.git
git clone https://github.com/golang/sys.git
git clone https://github.com/golang/time.git
git clone https://github.com/golang/text.git
cd $GOPATH/src
go get -u cloud.google.com/go/compute/metadata

# Use the script from Step 3: https://github.com/IBM/packer-plugin-ibmcloud
# Clone the project under Go path
mkdir -p $GOPATH/src/github.com/ibmcloud
cd $GOPATH/src/github.com/ibmcloud
#git clone git@github.com:IBM/packer-plugin-ibmcloud.git
git clone https://github.com/IBM/packer-plugin-ibmcloud.git > /dev/null

# Build the project
cd $GOPATH/src/github.com/ibmcloud/packer-builder-ibmcloud
# make sure you update the version under version/version.go if code has changes/features are added 
# Eg - current version is 0.1.0. When a new feature added to plugin then the new version should be 0.1.1
go build


# List the env and ssh key
cat $GOPATH/src/github.com/ibmcloud/packer-builder-ibmcloud/.env
cat $HOME/.ssh/id_rsa 
cat $HOME/.ssh/id_rsa.pub


# Create .env file:
cd $GOPATH/src/github.com/ibmcloud/packer-builder-ibmcloud/


# Run Packer:

source .env

# Edit the json file with proper mandatory and optional feilds 

packer validate examples/linux.json 
packer build examples/linux.json

echo "+============================================================+"
echo "|               Completed successfully!                      |"
echo "+============================================================+"