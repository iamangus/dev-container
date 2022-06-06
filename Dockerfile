FROM fedora:latest

ENV GH_TOKEN=""
ENV GH_REPO=""
ENV GOVER=1.17.7
ENV CSVER=4.4.0

#Installing NVM
SHELL ["/bin/bash", "--login", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

#Installing nodejs
RUN nvm install --lts

#Installing golang
WORKDIR /tmp/
RUN curl -O https://storage.googleapis.com/golang/go$GOVER.linux-amd64.tar.gz \
 && tar -xf go$GOVER.linux-amd64.tar.gz \
 && sudo chown -R root:root ./go \
 && sudo mv go /usr/local

RUN curl -fOL https://github.com/coder/code-server/releases/download/v$CSVER/code-server-$CSVER-amd64.rpm \
 && sudo rpm -i code-server-$CSVER-amd64.rpm
# sudo systemctl enable --now code-server@$USER
# Now visit http://127.0.0.1:8080. Your password is in ~/.config/code-server/config.yaml
