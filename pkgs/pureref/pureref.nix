# source: https://gist.github.com/Shou/e0428993564150885721dc8db482748c

{ pkgs, fetchurl }:

let
  pname = "pureref";
  version = "2.0.3";

  src = ./PureRef-2.0.3_x64.Appimage;

in

pkgs.runCommand "pureref" {
  buildInputs = with pkgs; [ appimage-run ];
} ''
  mkdir -p $out/bin
  cat <<-EOF > $out/bin/pureref
  #!/bin/sh
  ${pkgs.appimage-run}/bin/appimage-run ${src}
  EOF
  chmod +x $out/bin/pureref
''