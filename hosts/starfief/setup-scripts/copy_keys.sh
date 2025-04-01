#!/usr/bin/env bash

if [ $# -eq 0 ]; then
   echo -e "missing target host arguement, IP address for ssh remote_dest"
   exit 1
fi

refresh="$2"

echo -e $'\n**Copying Keys to Live ISO**\n'

remote_host="$1"
remote_user="root"

read -p $'Copy flake from local source (yes/n): ' download_check
if [[ "$download_check" == "yes" || "$download_check" == "y" ]]; then
    scp -r "/.nixflake" "${remote_user}@${remote_host}:/mnt/.nixflake"
fi
echo "---"

sops_host_key_local="$HOME/.ssh/secrets-key"
sops_host_key_target="/mnt/secrets_key"
scp "$sops_host_key_local" "${remote_user}@${remote_host}:${sops_host_key_target}"

if [[ "$refresh" != "yes" && "$refresh" != "y" ]]; then
    script="system_install.sh"
    scp "$script" "${remote_user}@${remote_host}:/mnt/${script}"

    github_key_local="$HOME/.ssh/id_ed25519_github"
    github_key_target="/id_ed25519_github"
    scp "$github_key_local" "${remote_user}@${remote_host}:${github_key_target}"
fi

echo -e $'\n**Now run the following commands:**'
echo "cd /mnt"
echo 'eval `ssh-agent`;ssh-add "/id_ed25519_github"'
echo -e $'./system_install\n'

ssh "${remote_user}@${remote_host}"