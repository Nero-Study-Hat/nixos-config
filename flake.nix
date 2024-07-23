{
    description = "My initial system flake.";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        plasma-manager = {
            url = "github:pjones/plasma-manager";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };
        hyprland = {
            url = "github:hyprwm/hyprland";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland-plugins = {
            url = "github:hyprwm/hyprland-plugins";
            inputs.hyprland.follows = "hyprland";
        };
    };

    outputs = { self, nixpkgs, nixpkgs-stable, home-manager, plasma-manager, hyprland,  ... }@inputs:
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
        rootPath = self;
    in {
        nixosConfigurations = {
            stardom = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [ 
                    ./configs/stardom/configuration.nix
                    inputs.hyprland.nixosModules.default
                ];
                specialArgs = { inherit inputs; };
            };
        };
        
        homeConfigurations = {
            nero = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = {
                    inherit inputs;
                    inherit rootPath;
                    pkgs-stable = import nixpkgs-stable {
                        inherit system;
                        config.allowUnfree = true;
                    };
                };

                modules = [
                    ./home-manager/home.nix
                    inputs.plasma-manager.homeManagerModules.plasma-manager
                ];
            };
        };
    };

}
