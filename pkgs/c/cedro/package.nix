# cedro.nix
{
  lib,
  stdenv,
  fetchFromGitHub,
  zip,
  ...
}:

stdenv.mkDerivation {
  pname = "cedro";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "shen390s";
    repo = "cedro";
    rev = "master";
    sha256 = "sha256-DLq7vC+4k2TMy5jKvQkFTy+xZmpvl0+DiWcd7CBVbgw=";
  };

  nativeBuildInputs = [ 
    zip
  ];

  installPhase = ''
     mkdir -p $out/bin
     cp bin/* $out/bin
  '';
}
