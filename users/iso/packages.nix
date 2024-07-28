{ pkgs-stable, ... }:

{
    home.packages = [
		# browsing and sharing
		pkgs-stable.brave
		pkgs-stable.simplescreenrecorder

		# code
        pkgs-stable.vscode
        pkgs-stable.git
        pkgs-stable.github-desktop

		# sys
        pkgs-stable.bash
        pkgs-stable.gparted
        pkgs-stable.htop
        pkgs-stable.cool-retro-term
        pkgs-stable.curl
        pkgs-stable.wget
        pkgs-stable.file
        pkgs-stable.tldr
    ];

    programs.tmux = {
        enable = true;
        package = pkgs-stable.tmux;
    };

    programs.htop = {
        enable = true;
        package = pkgs-stable.htop;
    };
}