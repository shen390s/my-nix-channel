{
  description = "Flake for some special packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils}:
    let
      supportedSystems = [ "x86_64-linux" ];
    in
      flake-utils.lib.eachSystem supportedSystems (
        system: let
          pkgs = nixpkgs.legacyPackages.${system};
          xpkgs = import ./default.nix { inherit pkgs; };
        in rec {
          packages = xpkgs;
          defaultPackage = xpkgs.uem;
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = xpkgs.uem.nativeBuildInputs;
          };

          devShell = self.devShells.${system}.default;
        }
      );
}

  
