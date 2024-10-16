# make sure not to use tabs, always spaces with nix

nix flake lock --update-input {input-name}

nix shell nixpkgs#git --command command-with-git-available
nix shell nixpkgs#git --command nix flake check "github:Nero-Study-Hat/nixos-config/${branch}" --no-write-lock-file
nix shell nixpkgs#file --command file {file-name}
nix run nixpkgs#python -- --version

nix shell nixpkgs#brightnessctl --command brightnessctl set 100%


# --- NixOS ---
# if you only want to update a single flake input, then the below command can be used
nix flake lock --update-input <input>

sudo nixos-rebuild switch --flake /{path/to/flake/dir}#stardom
# for situation without internet; TODO: make this the default so flake update only happens when specifically wanted
sudo nixos-rebuild switch --flake $FLAKE#starfief --no-update-lock-file
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

# --- ssh ---
eval `ssh-agent`;ssh-add id_rsa
ssh-keygen -t ed25519-sk -C "your_email@example.com" -f {output-path} # generating github ssh key pair
ssh-keygen -t ed25519 -C "your_email@example.com" -f {output-path} # no hardware key requirement
ssh -vT git@github.com # helps when new key is not working