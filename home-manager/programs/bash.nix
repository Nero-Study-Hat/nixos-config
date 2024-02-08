{
    home.packages = with pkgs; [ bash-completion ]

    programs.bash = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
            cl = "clear"; # yes I am this lazy, generally I ctrl+l
        };
        historyIgnore = [ "ls" "cd" "cl" "clear" "exit" ];
    };
}