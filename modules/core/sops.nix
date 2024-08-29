{ inputs, options, config, lib, pkgs, rootPath, ... }:

with lib;
let
    cfg = config.system-modules.sops;
    secretspath = builtins.toString inputs.mysecrets;
in
{
    options.system-modules.sops = with types; {
        enable = mkEnableOption "Setup sops-nix with associated packages and config.";
    };

    config = mkIf cfg.enable {
        # TODO: test if sops command can be used to edit encrypted file in seprate user's home directory
        environment.systemPackages = with pkgs; [
            sops
            age
            ssh-to-age
        ];

        # options nicely documented https://dl.thalheim.io/
        sops = {
            defaultSopsFile = "${secretspath}/secrets.yaml";
            defaultSopsFormat = "yaml";
            validateSopsFiles = false;

            age = {
                # ssh key will be created for each host as part of manual install process
                # TODO: consider having this path point to "/etc/ssh/ssh_host_ed25519_key" for being user agnostic per host
                # find a way to pass user path if wanted as ~ alias doesn't work
                sshKeyPaths = [ "/home/nero/.ssh/ssh_host_ed25519_key" ];
                keyFile = "/var/lib/sops-nix/key.txt";
                generateKey = true;
            };

            secrets = {
                "nero-user-password".neededForUsers = true;
                "home-location" = { };
                "wifi/home-name" = { };
                "wifi/home-password" = { };
            };
        };
    };
}