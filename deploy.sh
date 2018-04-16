#!/usr/bin/env bash

if [[ "$TRAVIS_BRANCH" != "master" ]]; then
  echo "We're not on the master branch."
  # analyze current branch and react accordingly
  exit 0
fi

echo 'FTP_USER     '$1
echo 'FTP_PASSWORD '$2
echo 'FTP_SITE     '$3
echo 'FTP_PATH     '$4
echo ftp://$1:$2@$3/$4
curl --ftp-create-dirs -u "$1:$2" -T README.md                               ftp://$3/$4/README.md
curl --ftp-create-dirs -u "$1:$2" -T CHANGEME.md                             ftp://$3/$4/CHANGEME.md
curl --list-only -u "$1:$2" ftp://$3/$4/