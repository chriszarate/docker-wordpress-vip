#!/usr/bin/env bash

if [ ! -f docker-compose.yml ]; then
  echo "Please run this script from the root of the docker-wordpress-vip repo."
  exit 1
fi

# Clone repos. Change "wpcomvip/project" to your repo location.
for repo in \
  wpcomvip/project \
  Automattic/vip-go-mu-plugins
do
  # Clone repo if it is not in the "src" subfolder.
  if [ ! -d "src/${repo##*/}" ]; then
    echo "Cloning $repo in the \"src\" subfolder...."
    git clone --recursive git@github.com:$repo src/${repo##*/}
  fi
done
