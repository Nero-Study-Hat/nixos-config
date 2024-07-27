nix shell nixpkgs#git --command command-with-git-available
nix shell nixpkgs#git --command nix flake check "github:Nero-Study-Hat/nixos-config/${branch}" --no-write-lock-file

# --- NixOS ---
sudo nixos-rebuild switch --flake /{path/to/flake/dir}#stardom

# --- Home Manager ---
# more verbose logging
nix run home-manager -- build --flake /{path/to/flake/dir}#nero
result/activate

# in flake dir
home-manager switch --flake {path/to/flake/dir}#username

# --- iso image ---
nix build {path/to/flake/dir}#iso