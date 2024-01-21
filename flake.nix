{
    description = "My initial system flake."

    inputs = {
        nixpckgs.url = "nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager/release-23.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs: {
        nixosConfigurations = {
            # replace 'nixdom' with your hostname
            nixdom = nixpkgs.lib.nixosSystem {
                # might have to use apparently deprecated specialArgs method
                # because of lack of docs on _module.args
                _module.args = { inherit inputs; }; # Pass flake inputs to our config
                modules = [ 
                    ./nixos/configuration.nix
                ];
            };
        };
    };

}