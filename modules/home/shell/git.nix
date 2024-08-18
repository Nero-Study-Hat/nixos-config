{ pkgs, ... }:

{
    home.packages = with pkgs; [ git ];

    programs.git = {
        enable = true;
        userName = "Nero-Study-Hat";
        userEmail = "nerostudyhat@gmail.com";
    };
}