{ pkgs, pkgs-stable, rootPath, ... }:

let
    godot4-mono = pkgs.callPackage "${rootPath}/pkgs/godot4-mono" {}; # depends on dotnetCorePackages.sdk_version
in
{
    home.packages = [
		# browsing and sharing
		pkgs.brave
		pkgs.simplescreenrecorder

		# code
        pkgs.vscode
        pkgs.git
        pkgs.github-desktop

		# sys
        pkgs.bash
        pkgs.gparted
        pkgs.htop
        pkgs.cool-retro-term
        pkgs.curl
        pkgs.wget
        pkgs.file
        pkgs.tldr
    ];

    programs.tmux = {
        enable = true;
        package = pkgs.tmux;
    };

    programs.htop = {
        enable = true;
        package = pkgs.htop;
    };
}