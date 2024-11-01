#!/usr/bin/env bash

rm -rf ./update
mkdir -p ./update
pushd ./update
wget "https://github.com/lejianwen/rustdesk-api/releases/latest/download/linux-armv7l.tar.gz"
wget "https://github.com/rustdesk/rustdesk-server/releases/latest/download/rustdesk-server-linux-armv7.zip"
tar xvzf linux-armv7l.tar.gz
unzip rustdesk-server-linux-armv7.zip
chown -R admin:admin .
ls -l release/ armv7/
for s in fvapp-rustdesk{-relay,-id,}; do systemctl stop $s; done
rm -rf ../{resources,docs,apimain}
cp armv7/hbb* release/apimain ../
cp -ar release/resources ../
cp -ar release/docs ../
cp -arn release/conf ../
mkdir ../data
mkdir -p /var/run/rustdesk
systemctl start fvapp-rustdesk
popd
rm -rf ./update