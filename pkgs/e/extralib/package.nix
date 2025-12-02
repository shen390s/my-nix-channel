{
  lib,
  stdenv,
  pkgs
}:

let
  meta =  with lib; {
    description = "Extralib for build X cloud Engine";
    platforms = lib.platforms.unix;
  };
  pname = "extralib";
  version = "0.0.1";
in
stdenv.mkDerivation (finalAttrs: {
  pname = pname;
  version = version;
                 
  src = builtins.fetchGit {
    url = "ssh://forgejo@gitea.shenrs.eu/nexa/extralibs.git";
    rev = "9bd63d624b18049f68acddfd14a64e6d98bbb9fe";
  };

  nativeBuildInputs = [
    pkgs.meson
    pkgs.ninja
  ];

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    cat >$out/lib/pkgconfig/extralibs.pc <<EOF
    prefix=$out
    exec_prefix=\''${prefix}
    libdir=$out/lib
    includedir=\''${prefix}/include

    Name: ${pname}
    Description: ${meta.description}
    Version: ${version}
    Libs: -L\''${libdir} -lzlog
    Cflags: -I\''${includedir}
    EOF
  '';
  
  inherit meta;
})
