{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    ./vmtest-hardware-configuration.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
  };

  nix.settings = {
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  networking.hostName = "stardom";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };

  users.users = {
    nero = {
      initialPassword = "nixisreallycool";
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager"];
    };
  };

  system.stateVersion = "24.05";
}