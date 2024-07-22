# { lib, config, options, pkgs, ... }:

# with lib; let
#     cfg = config.modules.test;
# in
# {
#     options.modules.test = {
#         name = mkOpt str "boo" "The package to be installed.";
#     };

#     config = mkIf (cfg.name == "hollywood") {
#         environment.systemPackages = [ pkgs.hollywood ];
#     };
# }

{ inputs, config, ... }:

{
	environment.systemPackages = [ pkgs.hollywood ];
}