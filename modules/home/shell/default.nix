{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.home-modules.shell;
in
{
    # if something grows in complexity and/or size then move it from this file to its own file to import
    # and extend the namespace declared in this file
    imports = [
        ./git.nix
        ./packages.nix
        ./test.nix
    ];

    options.home-modules.shell = with types; {
        enable-all = mkEnableOption "Enable all shell packages here.";
        
        bash-enable = mkEnableOption "Enable bash.";
        bash-pkg = mkOption {
            type = package;
            default = pkgs.bash;
        };

        direnv-enable = mkEnableOption "Enable direnv.";
        direnv-pkg = mkOption {
            type = package;
            default = pkgs.nix-direnv;
        };
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
        ( mkIf (cfg.enable-all || cfg.direnv-enable)
        {
            home.packages = [ cfg.direnv-pkg ];
            programs.direnv = {
                enable = true;
                enableBashIntegration = true;
                nix-direnv.enable = true;
            };
        })

        ( mkIf (cfg.enable-all || cfg.git-enable)
        {
            home.packages = with pkgs; [ git ];
            programs.git = {
                enable = true;
                userName = "Nero-Study-Hat";
                userEmail = "nerostudyhat@gmail.com";
            };
        })
    ];
}