{ pkgs ? import <nixpkgs> {}}:

pkgs.mkShell {
    name = "virtual desktop switcher C project";
    packages = with pkgs; [
        glibc
        glibc.static
        gcc
        cmake
    ];
    shellHook = ''
        echo "Starting new shell";
    '';
}

# activate with -> nix-shell <nix_shell_file>