#!/bin/bash

DIRECTORY="/data/actions-runner"
PREP="prep.sh"

cd /data

# Install Python
if ! python3; then
    echo "INFO: Installing Python"
    apt-get update
    apt-get install -y python3 
fi

if ! python3; then
    echo "ERROR: Python cannot be installed"
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
    exit 1
fi

# Attempt to run a container if not in a container
if [ ! -f /.dockerenv  ]; then
	if ! docker run --rm hello-world; then
		echo "ERROR: Could not get docker to run the hello world container"
		exit 2
	fi
fi

echo "INFO: Successfully verified docker installation!"

# Create a folder
if [ ! -d "$DIRECTORY" ]; then
    # Make directory
    mkdir /data/actions-runner && cd /data/actions-runner
    # Download the latest runner package
    curl -o actions-runner-linux-x64-2.316.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.316.1/actions-runner-linux-x64-2.316.1.tar.gz
    # Change permissions
    chmod +777 actions-runner-linux-x64-2.316.1.tar.gz
    # Allow it to run as root
    export {AGENT_ALLOW_RUNASROOT="1"}
    # Extract the installer
    tar xzf ./actions-runner-linux-x64-2.316.1.tar.gz
    # Config runner
    ./config.sh --url $URL --token $RUNNER_TOKEN
fi

if [ ! -e "$PREP" ]; then
    echo "ERROR Runner install failed"
    exit 3
fi

echo "INFO: Runner Successfuly Installed!"

chmod +x run.sh
source run.sh