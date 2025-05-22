# default.nix
{ pkgs ? import <nixpkgs> {} }:

{
  my-package = pkgs.callPackage ./my-package.nix {};
  # Add more packages here
}
