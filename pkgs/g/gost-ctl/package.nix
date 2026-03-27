# xbuild.nix
{
  lib,
  stdenv,
  pkgs,
  ...
}:

let
  gost-ctl=stdenv.mkDerivation {
    pname = "gost-ctl";
    version = "0.0.1";

    src = ./.;

    nativeBuildInputs = [ 
      pkgs.gost 
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp gost-ctl $out/bin
      chmod +x $out/bin/gost-ctl
  '';
  };

in
  gost-ctl
