nix shell nixpkgs#git --command command-with-git-available
nix shell nixpkgs#git --command nix flake check "github:Nero-Study-Hat/nixos-config/${branch}" --no-write-lock-file
nix shell nixpkgs#file --command file {file-name}
nix run nixpkgs#python -- --version

# --- NixOS ---
sudo nixos-rebuild switch --flake /{path/to/flake/dir}#stardom
# verbose log to file
sudo nixos-rebuild switch --flake ~/.nixflake#stardom -v --show-trace >>nixos-rebuild-log.txt 2>&1

# --- Home Manager ---
# more verbose logging
nix run home-manager -- build --flake /{path/to/flake/dir}#nero
result/activate

# in flake dir
home-manager switch --flake {path/to/flake/dir}#username

# --- iso image ---
nix build {path/to/flake/dir}#isoimage -o {target/output/path}

# --- cleaning ---
nix-collect-garbage
sudo nix-collect-garbage -d
nix-collect-garbage --delete-older-than {number of days}d
nix-store --gc
sudo nix-store --optimise
# useful pkg for cleaning is ncdu
# for me
cd / && ncdu --exclude "nero-priv-data" --exclude "nero-pub-data"