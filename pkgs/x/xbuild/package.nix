# xbuild.nix
{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  capnpc,
  cedro,
  ...
}:

let
  actual_xbuild=stdenv.mkDerivation {
    pname = "actual_xbuild";
    version = "0.0.1";

    src = fetchFromGitHub {
      owner = "shen390s";
      repo = "xbuild";
      rev = "master";
      #    sha256 = "sha256-DLq7vC+4k2TMy5jKvQkFTy+xZmpvl0+DiWcd7CBVbgw=";
      sha256 =  "sha256-DD/ErN13ydDwYV5BhF81dJEkDIx1bAFQccDKxjkF+qw=";
    };

    nativeBuildInputs = [ 
      pkgs.autoconf 
      pkgs.automake 
      pkgs.libtool
    ];

    preConfigure = ''
     aclocal && automake --add-missing && autoconf
  '';
  };

  xbuild = stdenv.mkDerivation {
    name = "xbuild-wrapper";

    unpackPhase = "true";
    
    nativeBuildInputs = [
      pkgs.makeWrapper
      pkgs.pkg-config
    ];

    buildInputs = [
      pkgs.gnumake
      pkgs.gcc
      pkgs.coreutils
      pkgs.bash
      pkgs.strace
      pkgs.go
      pkgs.xxd
      pkgs.patchelf
      pkgs.linux-pam
      pkgs.libtirpc
      pkgs.hwloc
      pkgs.libuv
      pkgs.readline
      pkgs.openssl
      pkgs.libcyaml
      pkgs.libyaml
      pkgs.elogind
      pkgs.sqlite
      pkgs.python3
      pkgs.ncurses
      capnpc
      cedro
    ];

    propagatedBuildInputs = [
      actual_xbuild
    ];

    buildCommand = ''
      mkdir -p $out/bin
      for bin in ${actual_xbuild}/bin/*; do
         makeWrapper "$bin" "$out/bin/$(basename $bin)" \
            --prefix PATH : ${pkgs.lib.makeBinPath xbuild.buildInputs} \
            --prefix PKG_CONFIG_PATH : ${pkgs.lib.makeSearchPathOutput "dev" "lib/pkgconfig" xbuild.buildInputs} \
	          --set AUTO_DETECT_PKG_CONFIG_PATH no 
      done
    '';
  };
in
  xbuild
