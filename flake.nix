{
    description = "My initial system flake.";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
        system = "x86_64-linux";
        nixpkgs.config.allowUnfree = true;
        # lib = nixpkgs.lib;
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    in {
        nixosConfigurations = {
            stardom = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [ ./configs/configuration.nix ];
                specialArgs = { inherit inputs; };
            };
        };
        homeConfigurations = {
            nero = home-manager.nixpkgs.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [ ./home-manager/home.nix ];
            };
        };
    };

}