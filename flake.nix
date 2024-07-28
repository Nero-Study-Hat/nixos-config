{
    description = "My initial system flake.";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixos-generators = {
            url = "github:nix-community/nixos-generators";
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
        nixos-generators,
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
        lib = nixpkgs.legacyPackages.x86_64-linux.lib;
        defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
        rootPath = self;
    in {
        nixpkgs.overlays = [ hyprland.overlays.default ];

        packages.x86_64-linux = {
            isoimage = nixos-generators.nixosGenerate {
                inherit system;
                modules = [
                    ./hosts/minimal-dev/configuration.nix
                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.iso = import ./users/iso/home.nix;

                        home-manager.extraSpecialArgs = {
                            inherit inputs;
                            inherit rootPath;
                            pkgs-stable = import nixpkgs-stable {
                                inherit system;
                                config.allowUnfree = true;
                            };
                            inherit hyprland hyprland-plugins hyprkool hyprland-virtual-desktops;
                        };
                    }
                ];
                specialArgs = { inherit inputs; };
                format = "iso";
            };
            stardom-vm = nixos-generators.nixosGenerate {
                inherit system;
                modules = [ 
                    ./hosts/stardom-vm/configuration.nix
                ];
                specialArgs = { inherit inputs; };
                format = "virtualbox";
            };
            hyprkool-testvm = nixos-generators.nixosGenerate {
                inherit system;
                modules = [
                    ./hosts/minimal-dev/configuration.nix
                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.tester = import ./users/test-users/hyprkool/home.nix;

                        home-manager.extraSpecialArgs = {
                            inherit inputs;
                            pkgs-stable = import nixpkgs-stable {
                                inherit system;
                                config.allowUnfree = true;
                            };
                            inherit hyprland hyprkool;
                        };
                    }
                ];
                specialArgs = { inherit inputs; };
                format = "virtualbox";
            };
        };

        nixosConfigurations = {
            stardom = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [ 
                    ./hosts/stardom/configuration.nix
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
                    inherit hyprland hyprland-plugins hyprkool hyprland-virtual-desktops;
                };

                modules = [
                    ./users/nero/home.nix
                    inputs.plasma-manager.homeManagerModules.plasma-manager
                ];
            };
        };
    };

}
