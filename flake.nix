{
    description = "My initial system flake.";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        plasma-manager = {
            url = "github:pjones/plasma-manager";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };
    };

    outputs = { self, nixpkgs, home-manager, plasma-manager, ... }@inputs:
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    in {
        nixosConfigurations = {
            stardom = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [ ./configs/stardom/configuration.nix ];
                specialArgs = { inherit inputs; };
            };
        };
        homeConfigurations = {
            nero = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = {inherit inputs;};

                modules = [
                    ./home-manager/home.nix
                    inputs.plasma-manager.homeManagerModules.plasma-manager
                ];
            };
        };
    };

}
