{ options, config, lib, pkgs, pkgs-stable, ... }:

with lib;
let
    cfg = config.home-modules.shell.ssh-client;
in
{
    options.home-modules.shell.ssh-client = with types; {
        enable = mkEnableOption "Enable ssh client.";
    };

    config = mkIf cfg.enable {
        programs.ssh = {
            enable = true;
            addKeysToAgent = "confirm";

            extraConfig = ''
                Host github.com
                    User git
                    Hostname github.com
                    PreferredAuthentications publickey
                    IdentityFile ~/.ssh/id_ed25519_github
            '';
        };
    };
}