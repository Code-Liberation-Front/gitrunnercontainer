#!/bin/bash

DIRECTORY="/data/actions-runner"
PREP="/data/actions-runner/run.sh"
SUDOER="/etc/sudoers"

cd /data

# Install Python
if ! python3; then
    echo "INFO: Installing Python"
    apt-get update
    apt-get install -y python3 
fi

if ! python3; then
    echo "ERROR: Python cannot be installed"
    exit 1
fi

# Install docker
if ! docker --version; then
    echo "INFO: Installing Docker"
    # Add Docker's official GPG key:
    apt-get update
    apt-get -y install apt-utils
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
    apt-get -y install ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
    apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

fi
	
if ! docker --version; then
    echo "ERROR: Docker install failed"
    exit 2
fi

# Attempt to run a container if not in a container
if [ ! -f /.dockerenv  ]; then
	if ! docker run --rm hello-world; then
		echo "ERROR: Could not get docker to run the hello world container"
		exit 3
	fi
fi

echo "INFO: Successfully verified docker installation!"

# Create user to run actions and add them to groups
#apt install sudo
#useradd actions
#usermod -aG docker actions
#echo 'actions ALL=(sudo) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

# Create a folder
if [ ! -d "$DIRECTORY" ]; then
    mkdir /data/actions-runner
    #sudo -u actions /data/action.sh
    cd /data/actions-runner
    curl -o actions-runner-linux-x64-2.316.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.316.1/actions-runner-linux-x64-2.316.1.tar.gz
    tar xzf ./actions-runner-linux-x64-2.316.1.tar.gz
    RUNNER_ALLOW_RUNASROOT="1" ./config.sh --url $URL --token $RUNNER_TOKEN

fi

if [ ! -e "$PREP" ]; then
    echo "ERROR Runner install failed"
    exit 4
fi

echo "INFO: Runner Successfuly Installed!"

chmod +x /data/actions-runner/run.sh
source /data/actions-runner/run.sh