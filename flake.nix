{
    description = "My initial system flake.";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
        lib = nixpkgs.lib;
        pkgs = nixpkgs.legacyPackages.${"x86_64-linux"};
    in {
        nixosConfigurations = {
            nixdom = lib.nixosSystem {
                system = "x86_64-linux";
                modules = [ ./configs/configuration.nix ];
                _module.args = { inherit inputs; };
            };
        };
        homeConfigurations = {
            nero = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [ ./home-manager/home.nix ];
            };
        };
    };

}