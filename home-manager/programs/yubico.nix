{ pkgs, ... }:

{
    home.packages = with pkgs; [ yubico-pam ];

    security.pam.yubico = {
        enable = true;
    };
}