# partioning (for VirtBox-VM) (cmds src -> https://gist.github.com/Vincibean/baf1b76ca5147449a1a479b5fcc9a222)

parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart primary 512MiB -8GiB
parted /dev/sda -- mkpart primary linux-swap -8GiB 100%
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda -- set 3 esp on

mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3

mount -L nixos /mnt
mkdir -p /mnt/boot/efi
mount -L boot /mnt/boot/efi
swapon /dev/sda2

---

export NIX_CONFIG="experimental-features = nix-command flakes"
export branch="feat/5-get-packages-installed-in-home-by-a-specific-file"
nix shell nixpkgs#git --command nix flake clone "github:Nero-Study-Hat/nixos-config/${branch}" --dest /mnt/.n

# Test
nix shell nixpkgs#git --command nix flake check "github:Nero-Study-Hat/nixos-config/${branch}" --no-write-lock-file

# Install
fix swap partition UUID in harware-configuration.nix file
nix shell nixpkgs#git --command nixos-install --impure --flake /mnt/.n#stardom

# in virtualbox, make sure 'Enable EFI' is checked

# To build home-manager config.
# Approach 1 (from home dir) - tested working
nix run home-manager -- build --flake /.n#nero
result/activate
# reboot
# Aproach 2 (from flake dir) - not tested working
nix run . -- build --flake .
exec $SHELL -l
# if changes have been made to home config at this point, to update you can
home-manager switch --flake .