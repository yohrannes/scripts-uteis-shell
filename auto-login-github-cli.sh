#!/bin/bash

ARCHITECTURE=$(hostnamectl | grep Arch | awk '{print $2}')
VERSION=`curl  "https://api.github.com/repos/cli/cli/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c2-`
wget https://github.com/cli/cli/releases/download/v${VERSION}/gh_${VERSION}_linux_${ARCHITECTURE}.tar.gz
tar xvf gh_${VERSION}_linux_${ARCHITECTURE}.tar.gz
sudo cp gh_${VERSION}_linux_${ARCHITECTURE}/bin/gh /usr/local/bin/
gh version
gh auth login