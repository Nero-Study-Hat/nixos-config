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

    programs.plasma = {
        enable = true;

        workspace = {
            clickItemTo = "select";
            lookAndFeel = "org.kde.breezedark.desktop";
            #   cursorTheme = "Bibata-Modern-Ice";
            #   iconTheme = "Papirus-Dark";
            #   wallpaper = "${pkgs.libsForQt5.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
        };


        shortcuts = {
            kwin = {
                "Expose" = "Meta+,";
                "Switch Window Down" = "Ctrl+Alt+Down";
                "Switch Window Left" = "Ctrl+Alt+Left";
                "Switch Window Right" = "Ctrl+Alt+Right";
                "Switch Window Up" = "Ctrl+Alt+Up";
                "Show Desktop Grid" = "Meta+A";
            };
        };


        configFile = {
            "kwinrc"."Desktops"."Number" = {
                value = 4;
                # Forces kde to not change this value (even through the settings app).
                immutable = true;
            };
            "kwinrc"."Desktops"."Rows" = {
                value = 2;
                immutable = true;
            };
            "kwinrc"."Windows"."RollOverDesktops" = {
                value = true;
                immutable = true;
            };
            "kwinrc"."Plugins"."bismuthEnabled" = {
                value = true;
                immutable = true;
            };
        };
    };
}