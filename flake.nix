{
  description = "Flake for some special packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    npm-lockfile-fix = {
      url = "github:jeslie0/npm-lockfile-fix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, uv2nix, pyproject-nix, pyproject-build-systems, npm-lockfile-fix }:
    let
      supportedSystems = [ "x86_64-linux" ];
    in
      flake-utils.lib.eachSystem supportedSystems (
        system: let
          pkgs = nixpkgs.legacyPackages.${system};
          xpkgs = import ./default.nix {
            inherit pkgs uv2nix pyproject-nix pyproject-build-systems;
            npm-lockfile-fix-pkg = npm-lockfile-fix.packages.${system}.default;
          };
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
