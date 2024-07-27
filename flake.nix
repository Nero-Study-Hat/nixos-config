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
            type = "git";
            url = "https://github.com/hyprwm/Hyprland?ref=refs/tags/v0.41.2";
            submodules = true;
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland-plugins = {
            url = "github:hyprwm/hyprland-plugins";
            inputs.hyprland.follows = "hyprland";
        };
        hyprkool = {
            url = "github:thrombe/hyprkool";
            inputs.hyprland.follows = "hyprland";
        };
        hyprland-virtual-desktops = {
            url = "github:levnikmyskin/hyprland-virtual-desktops/dev";
            inputs.hyprland.follows = "hyprland";
        };
    };

    outputs = {
        self,
        nixpkgs,
        nixpkgs-stable,
        home-manager,
        plasma-manager,
        hyprland,
        hyprland-plugins,
        hyprkool,
        hyprland-virtual-desktops,
        ... 
    }@inputs:
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
        rootPath = self;
    in {
        nixpkgs.overlays = [ hyprland.overlays.default ];

        nixosConfigurations = {
            stardom = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [ 
                    ./hosts/stardom/configuration.nix
                ];
                specialArgs = { inherit inputs; };
            };

            # exampleIso = nixpkgs.lib.nixosSystem {
            #     specialArgs = { inherit inputs; };
            #     modules = [
            #         ./hosts/isoimage/configuration.nix
            #     ];
            # };
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
                    inherit hyprland hyprland-plugins hyprkool hyprland-virtual-desktops;
                };

                modules = [
                    ./home-manager/home.nix
                    inputs.plasma-manager.homeManagerModules.plasma-manager
                ];
            };
        };
    };

}
