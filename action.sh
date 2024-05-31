#!/bin/bash

whoami
cd /data/actions-runner
curl -o actions-runner-linux-x64-2.316.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.316.1/actions-runner-linux-x64-2.316.1.tar.gz
tar xzf ./actions-runner-linux-x64-2.316.1.tar.gz
./config.sh --url $URL --token $RUNNER_TOKEN
chmod +x run.sh
source run.sh