{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  ...
}:

stdenv.mkDerivation {
  pname = "cetcd";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "shen390s";
    repo = "cetcd";
    rev = "master";
#    sha256 = "sha256-9dzSc3w+yxYzsF/rZe3qIarKOpjt2zvIyjuS5FXngIM=";
  };

  nativeBuildInputs = [
    pkgs.make
    pkgs.curl
    pkgs.pkg-config
    pkgs.yajl
  ];

  configurePhase = ''
      true
  '';
  
  buildPhase = ''
      make prefix=$out
  '';           

  installPhase = ''
      runHook preInstall
      make install prefix=$out
      runHook postInstall
  '';
}
