#!/usr/bin/env bash

if [ $# -eq 0 ]; then
   echo -e "missing target host arguement, IP address for ssh remote_dest"
   exit 1
fi

echo -e $'\n**Copying Keys to Live ISO**\n'
github_key_target="/mnt/etc/ssh/id_ed25519_github"

remote_host="$1"
remote_user="root"

ssh "${remote_user}@${remote_host}" 'bash -s' <<EOT
    mkdir -p /mnt/etc/ssh
EOT

sops_host_key_local="$HOME/.ssh/secrets-key"
sops_host_key_target="/mnt/etc/ssh/ssh_host_ed25519_key"
scp "$sops_host_key_local" "${remote_user}@${remote_host}:${sops_host_key_target}"

github_key_local="$HOME/.ssh/id_ed25519_github"
scp "$github_key_local" "${remote_user}@${remote_host}:${github_key_target}"

echo -e $'\n**Now run the following commands:**\n'
echo "mv /system_install.sh /mnt/system_install.sh"
echo "cd /mnt"
echo 'eval `ssh-agent`;ssh-add "/mnt/etc/ssh/id_ed25519_github"'
echo "./system_install"

ssh "${remote_user}@${remote_host}"