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
    rev = "master";
    sha256 = "sha256-U+yUYYvfhPjvADtHsjN5LvOUzFEXZrTmmpqfypf/4Ik=";
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
      cmake --preset=ci-linux_x86_64 -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTING=OFF
  '';
  
  buildPhase = ''
      cmake --build --preset=ci-tests
  '';           

  installPhase = ''
     mkdir -p $out/bin
     mkdir -p $out/include
     mkdir -p $out/lib
     cp build/capnpc-c $out/bin
     cp build/libCapnC_Runtime.a $out/lib
     cp lib/capnp_c.h $out/include
  '';
}
