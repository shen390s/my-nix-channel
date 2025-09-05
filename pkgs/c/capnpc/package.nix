{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  ...
}:

stdenv.mkDerivation {
  pname = "capnpc";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "shen390s";
    repo = "c-capnproto";
    rev = "main";
    sha256 = "sha256-PapM3rCtA8D3uC1YAdzxqR9qvHa15849XmbhBBLuoO0=";
  };

  nativeBuildInputs = [
    pkgs.cmake
    pkgs.ninja
    pkgs.capnproto
  ];

  preConfigure = ''
     cp "$src/CMakePresets.json" .
  '';
  
  configurePhase = ''
      cmake --preset=ci-linux_x86_64 -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTING=OFF -DCMAKE_INSTALL_PREFIX=$out
  '';
  
  buildPhase = ''
      cmake --build --preset=ci-tests
  '';           

  installPhase = ''
      cmake --install build
  '';
}
