nix shell nixpkgs#git --command command-with-git-available
nix shell nixpkgs#git --command nix flake check "github:Nero-Study-Hat/nixos-config/${branch}" --no-write-lock-file

# --- Home Manager ---
# more verbose logging
nix run home-manager -- build --flake /.n#nero
result/activate

# in flake dir
home-manager switch --flake .#username