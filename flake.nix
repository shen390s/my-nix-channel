{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    mypkgs.url  = "github:shen390s/my-nix-channel?ref=master";
  };

  outputs = { self, nixpkgs, mypkgs}:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./default.nix { inherit pkgs; inherit mypkgs;});
    };
}

  
