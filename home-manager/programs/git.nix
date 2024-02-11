{ pkgs, ... }:

{
    home.packages = with pkgs; [ 
        git
        github-desktop
     ];

    programs.git = {
        enable = true;
        userName = "Nero-Study-Hat";
        userEmail = "nerostudyhat@gmail.com";
    };
}