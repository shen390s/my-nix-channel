{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  ...
}:

let
  pname = "cetcd";
  version = "1.0.0";
  meta = with lib; {
    description = "c binding of etcd client api";
    homepage = "https://github.com/shafreeck/cetcd";
    license = lib.license.apsl20;
  };
in
stdenv.mkDerivation {
  pname = pname;
  version = version;

  src = fetchFromGitHub {
    owner = "shen390s";
    repo = "cetcd";
    rev = "master";
    sha256 = "sha256-BTJXrJyjPp5ynHH5Ct91PFiWATzBal4rsnX84wJ0nCg=";
  };

  nativeBuildInputs = [
    pkgs.gnumake
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

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    cat >$out/lib/pkgconfig/cetcd.pc <<EOF
    prefix=$out
    exec_prefix=\''${prefix}
    libdir=$out/lib
    includedir=\''${prefix}/include

    Name: ${pname}
    Description: ${meta.description}
    Version: ${version}
    Libs: -L\''${libdir} -lcetcd
    Cflags: -I\''${includedir}
    EOF
  '';

}
