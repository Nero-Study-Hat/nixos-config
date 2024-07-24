{pkgs, ...}: {
  hyprkool = pkgs.callPackage ({
    lib,
    fetchFromGitHub,
    cmake,
    hyprland,
    hyprkool,
  }:
    hyprlandPlugins.mkHyprlandPlugin pkgs.hyprland {
      pluginName = "hyprland";
      version = "0.7.0";

      src = fetchFromGitHub {
        owner = "thrombe";
        repo = "hyprkool";
        rev = "3cafd73";
      };

      # any nativeBuildInputs required for the plugin
      nativeBuildInputs = [cmake];

      # set any buildInputs that are not already included in Hyprland
      # by default, Hyprland and its dependencies are included
      buildInputs = [];

      meta = {
        homepage = "https://github.com/thrombe/hyprkool";
        description = "An opinionated Hyprland plugin that tries to replicate the feel of KDE activities and grid layouts.";
        license = lib.licenses.mit;
        platforms = lib.platforms.linux;
        maintainers = with lib.maintainers; [thrombe];
      };
    });
}