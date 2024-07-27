{ pkgs, ... }:

{
    home.packages = with pkgs; [ bash-completion ];

    programs.bash = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
            cl = "clear";
        };
        historyIgnore = [ "ls" "cd" "cl" "clear" "exit" ];
    };
}