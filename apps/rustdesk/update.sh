#!/usr/bin/env bash

rm -rf ./update
mkdir -p ./update
pushd ./update
for s in fvapp-rustdesk{-relay,-id,}; do systemctl stop $s; done
wget "https://github.com/lejianwen/rustdesk-api/releases/latest/download/linux-armv7l.tar.gz"
curl -sL https://api.github.com/repos/rustdesk/rustdesk-server/releases/latest | egrep 'download_url.+armhf' | awk -F'"' '{print $4}' | while read deb; do wget $deb; dpkg -i ./$(basename $deb); rm ./$(basename $deb); done
for act in {stop,disable}; do for bin in rustdesk-{hbbr,hbbs}; do echo systemctl $act $bin; done; done
tar xvzf linux-armv7l.tar.gz
chown -R admin:admin .
ls -l release/ armv7/
rm -rf ../{resources,docs,apimain}
cp armv7/hbb* release/apimain ../
cp -ar release/resources ../
cp -ar release/docs ../
pushd release/conf
mkdir -p /var/run/rustdesk-server
sed -i 's#\(lang: \)"[^"]*"#\1"en"#g' config.yaml
sed -i 's#\(level: \)"[^"]*"\([^"]*debug[^"]*\)#\1"info"\2#g' config.yaml
sed -i 's#\(key-file: \)"./conf/data\([^"]*\)"#\1 "./conf\2"#g' config.yaml
sed -i 's#\(path: \)"[^"]*log[^"]*"#\1""#g' config.yaml
sed -i 's#\(file-dir: \)"./runtime/cache\([^"]*\)"#\1 "/var/run/rustdesk-server\2"#g' config.yaml
popd
cp -arn release/conf ../
mkdir ../data
if [ -f ../conf/id_ed25519 ]; then
    systemctl start fvapp-rustdesk
else
    echo "Skipping starting services. You must generate keys and database inside conf directory:"
    echo "  cd /apps/rustdesk/conf && ../hbbs # Exit with Control-C"
    echo "Verify your configuration settings and then start the main service:"
    echo "  systemctl start fvapp-rustdesk"
fi
popd
rm -rf ./update