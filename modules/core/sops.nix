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
        environment.systemPackages = with pkgs; [
            sops
            age
            ssh-to-age
        ];

        systemd.services."sometestservice" = {
            script = ''
                echo "
                Hey bro! I'm a service, and imma send this secure password:
                $(cat ${config.sops.secrets."myservice/my_subdir/my_secret".path})
                located in:
                ${config.sops.secrets."myservice/my_subdir/my_secret".path}
                to database and hack the mainframe
                " > /var/lib/sometestservice/testfile
            '';
            serviceConfig = {
                User = "sometestservice";
                WorkingDirectory = "/var/lib/sometestservice";
            };
        };

        users.users.sometestservice = {
            home = "/var/lib/sometestservice";
            createHome = true;
            isSystemUser = true;
            group = "sometestservice";
        };
        users.groups.sometestservice = { };

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

            # all secrets must have an owner
            secrets = {
                "password" = {
                    owner = "nero";
                };
                example-key = {
                    owner = "nero";
                };
                "myservice/my_subdir/my_secret" = {
                    owner = "sometestservice";
                };
            };
        };
    };
}