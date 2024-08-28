{ inputs, options, config, lib, pkgs, rootPath, sops, ... }:

with lib;
let
    cfg = config.system-modules.sops;
    secretspath = builtins.toString inputs.mysecrets;
in
{
    options.system-modules.yubikey = with types; {
        enable = mkEnableOption "Whether to setup yubikey support.";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            sops
            age
            ssh-to-age
        ];

        sops = {
            defaultSopsFile = "${secretspath}/secrets.yaml";
            validateSopsFiles = false;
        };

        age = {
            # ssh key will be created for each host as part of manual install process
            # TODO: consider having this path point to "/etc/ssh/ssh_host_ed25519_key" for being user agnostic per host 
            sshKeyPaths = [ "~/.ssh/ssh_host_ed25519_key" ];
            keyFile = "/var/lib/sops-nix/key.txt";
            generateKey = true;
        };

        secrets = {
            password = { };
        };
    };
}