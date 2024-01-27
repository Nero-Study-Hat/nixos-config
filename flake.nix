{
    description = "My initial system flake.";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs: {
        nixosConfigurations = {
            nixdom = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [ 
                    ./configs/configuration.nix
                ];
            };
        };
    };

}

# Command:
# nixos-install --flake github:Nero-Study-Hat/nixos-config/1-get-base-nixos-setup-with-flakes-handled#nixdom