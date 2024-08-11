{ pkgs, ... }:

{
    home.packages = with pkgs; [
        bash
        bash-completion
        nix-direnv
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

    programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
    };
}