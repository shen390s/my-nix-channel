{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs}:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        xbuild = pkgs.callPackage ./pkgs/x/xbuild/package.nix {};
        cedro  = pkgs.callPackage ./pkgs/c/cedro/package.nix {};
      });
    };
}
