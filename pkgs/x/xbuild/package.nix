# xbuild.nix
{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  ...
}:

let
  actual_xbuild=stdenv.mkDerivation {
    pname = "xbuild";
    version = "0.0.1";

    src = fetchFromGitHub {
      owner = "shen390s";
      repo = "xbuild";
      rev = "master";
      #    sha256 = "sha256-DLq7vC+4k2TMy5jKvQkFTy+xZmpvl0+DiWcd7CBVbgw=";
      sha256 =  "sha256-gYIYd3J4mCJJU0yJ+2xL/5URKo+M8T2Q9CWLbxQ2rtQ=";
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
  wrapped_xbuild = stdenv.mkDerivation {
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
    ];

    propagatedBuildInputs = [
      actual_xbuild
    ];

    buildCommand = ''
      mkdir -p $out/bin
      for bin in ${actual_xbuild}/bin/*; do
         makeWrapper "$bin" "$out/bin/$(basename $bin)" \
            --prefix PATH : ${pkgs.lib.makeBinPath wrapped_xbuild.buildInputs} \
            --prefix PKG_CONFIG_PATH : ${pkgs.lib.makeSearchPathOutput "dev" "lib/pkgconfig" wrapped_xbuild.buildInputs} \
	    --set AUTO_DETECT_PKG_CONFIG_PATH no 
      done
    '';
  };
in
  wrapped_xbuild
