# my-package.nix
{ stdenv }:

stdenv.mkDerivation {
  name = "my-package";
  src = ./.;
  installPhase = "mkdir -p $out; echo 'Hello, Nix!' > $out/hello";
}
