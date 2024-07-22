{ lib, config, options, pkgs, ... }:

let
    cfg = config.mytest;
in
{
    options.mytest = {
		enable = lib.mkEnableOption "test module";
		name = lib.mkOption {
			type = lib.types.str;
			default = "boo";
			example = "hollywood";
			description = "The package to be installed.";
		};
    };

	config = lib.mkMerge [
		(lib.mkIf (cfg.name == "hollywood") { environment.systemPackages = [ pkgs.hollywood ]; })
		(lib.mkIf (cfg.name == "bat") { environment.systemPackages = [ pkgs.bat ]; })
	];

}


# lib.mkIf (cfg.name == "hollywood")

# {
# 	environment.systemPackages = [ pkgs.hollywood ];
# }