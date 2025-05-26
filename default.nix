# default.nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in
{
  xbuild = pkgs.callPackage ./pkgs/x/xbuild/package.nix {};
}
