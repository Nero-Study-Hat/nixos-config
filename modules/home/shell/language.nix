{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.home-modules.shell.language;
in
{
    options.home-modules.shell.language = with types; {
        
        bash-enable = mkEnableOption "Enable and configure bash.";
        bash-pkg = mkOption {
            type = package;
            default = pkgs.bash;
        };

        # zsh-enable = mkEnableOption "Enable direnv.";
        # zsh-pkg = mkOption {
        #     type = package;
        #     default = pkgs.nix-direnv;
        # };
    };

    config = mkMerge [
        ( mkIf (cfg.enable-all || cfg.bash-enable)
        {
            home.packages = [
                cfg.bash-pkg
                pkgs.bash-completion
            ];
            programs.bash = {
                enable = true;
                enableCompletion = true;
                shellAliases = {
                    cl = "clear";
                };
                historyIgnore = [ "ls" "cd" "cl" "clear" "exit" ];
                bashrcExtra = ''eval "$(direnv hook bash)"'';
            };
        })
    ];
}