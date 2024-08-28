{
    description = "My initial system flake.";

    inputs = {
        mysecrets = {
            url = "git+ssh://git@github.com/Nero-Study-Hat/nixos-secrets?rev=6dee3dc218572718a860a757ee65a9476d0757d1";
            flake = false;
        };

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

        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        plasma-manager = {
            url = "github:pjones/plasma-manager";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };
        
        hyprland = {
            url = "git+https://github.com/hyprwm/Hyprland/?ref=refs/tags/v0.41.2&rev=918d8340afd652b011b937d29d5eea0be08467f5&submodules=1";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland-virtual-desktops = {
            url = "github:levnikmyskin/hyprland-virtual-desktops/dev";
            inputs.hyprland.follows = "hyprland";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprkool = {
            url = "github:thrombe/hyprkool/0.7.1";
            inputs.nixpkgs.follows = "nixpkgs-stable";
            inputs.nixpkgs-unstable.follows = "nixpkgs";
            inputs.hyprland.follows = "hyprland";
        };
    };

    outputs = {
        self,
        nixpkgs,
        nixpkgs-stable,
        home-manager,
        nixos-generators,
        sops-nix,
        ... 
    }@inputs:
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        lib = nixpkgs.legacyPackages.x86_64-linux.lib;
        defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
        rootPath = self;
    in {
        nixpkgs.overlays = [ inputs.hyprland.overlays.default ];


        nixosConfigurations = {
            stardom = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [ 
                    ./hosts/stardom/configuration.nix
                    inputs.sops-nix.nixosModules.sops
                ];
                specialArgs = { inherit inputs; };
            };
            starfief = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [ 
                    ./hosts/starfief/configuration.nix
                    inputs.sops-nix.nixosModules.sops
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
                    ./hosts/stardom/users/nero/home.nix
                    inputs.plasma-manager.homeManagerModules.plasma-manager
                ];
            };
            alaric = home-manager.lib.homeManagerConfiguration {
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
                    ./hosts/starfief/home.nix
                    inputs.plasma-manager.homeManagerModules.plasma-manager
                ];
            };
            bo = home-manager.lib.homeManagerConfiguration {
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
                    ./hosts/stardom/users/bo/home.nix
                    inputs.plasma-manager.homeManagerModules.plasma-manager
                ];
            };
        };

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
                        home-manager.users.tester = import ./users/test-hyprkool/home.nix;

                        home-manager.extraSpecialArgs = {
                            inherit inputs;
                            pkgs-stable = import nixpkgs-stable {
                                inherit system;
                                config.allowUnfree = true;
                            };
                        };
                    }
                ];
                specialArgs = { inherit inputs; };
                format = "virtualbox";
            };
        };
    };
}
