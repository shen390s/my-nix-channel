{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkgs,
}:

let
  meta =  with lib; {
    description = "convert c struct to json";
    homepage = "https://github.com/armink/struct2json";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
  pname = "struct2json";
  version = "1.0.0";
in
stdenv.mkDerivation (finalAttrs: {
  pname = pname;
  version = version;
                 
  src = fetchFromGitHub {
    owner = "shen390s";
    repo = "struct2json";
    rev = "master";
    hash = "sha256-ZCJC6NmdL4EASlJYlWym3rjPK6qaKGtZMQhY0GIqTTU=";
  };

  nativeBuildInputs = [
    pkgs.meson
    pkgs.ninja
    pkgs.pkgconf
  ];

  inherit meta;
})
