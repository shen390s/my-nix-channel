# xbuild.nix
{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation {
  pname = "xbuild";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "shen390s";
    repo = "xbuild";
    rev = "master";
    sha256 = "sha256-DLq7vC+4k2TMy5jKvQkFTy+xZmpvl0+DiWcd7CBVbgw=";
  };

  nativeBuildInputs = [ 
     autoconf 
     automake 
     libtool
  ];

  preConfigure = ''
     aclocal && automake --add-missing && autoconf
  '';
}
