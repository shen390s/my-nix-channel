# default.nix
let
  pkgs = import <nixpkgs> { config = {}; overlays = []; };
in
{
  xbuild = pkgs.callPackage ./pkgs/x/xbuild/package.nix {};
  cedro = pkgs.callPackage ./pkgs/c/cedro/package.nix {};
}
