#!/usr/bin/env bash
nix-shell -E 'with import <nixpkgs> {}; callPackage ./default.nix {}' -A make-deps --run 'eval "$makeDeps"'

# The source of this is from the still open nixpkgs PR #285941
# from github user ilikefrogs101