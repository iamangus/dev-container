#!/bin/bash
set -eu

#sudo rm -rf /home/coder/go/*

if [[ -z "${GH_REPO}" ]]; then
  echo "No github repo provided. Nothing to clone."
  CODEDIR="."
else
  CODEDIR=$(basename https://$GH_REPO)
  echo "Found github repo. Checking for a github personal access token."
  if [[ -z "${GH_TOKEN}" ]]; then
    echo "No github token provided. Cloning public repo."
    git clone https://$GH_REPO &
  else
    echo "found a github token. Cloning repo."
    git clone https://$GH_TOKEN@$GH_REPO &
  fi
fi

if [[ "$CODEDIR" == *".git"* ]]; then
  CODEDIR=${CODEDIR%".git"}
fi

export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

cp /tmp/.bashrc $HOME/.bashrc

/usr/local/go/bin/go install golang.org/x/tools/gopls@latest &

/usr/bin/code-server --install-extension golang.go &

wait

dumb-init /usr/bin/code-server --bind-addr 0.0.0.0:8080 "$CODEDIR"
