## RustDesk-API for ReadyNAS 6 (WiP)

Config package to setup RustDesk API on the armv7 based ReadyNAS system.

- Copy the contents of ./apps/ to /apps/ on ReadyNAS. E.g. `rsync -av ./apps/ root@readynas.local:/apps/`
- SSH into ReadyNAS system. E.g. `ssh root@readynas.local`
- Exec: `/frontview/bin/fvapps` to make RN pick up the service definitions.
- Exec: `cd /apps/rustdesk && chmod +x ./update.sh`
- Exec: `./update.sh` (This should pull all necessary binaries and resources, copy them in place, and restart services.)
- Upon successful execution of above commands..
- Adjust /apps/rustdesk/conf/config.yaml and /apps/rustdesk/conf/env
- Restart services once more: `for s in fvapp-rustdesk{-relay,-id,}; do systemctl restart $s; done`