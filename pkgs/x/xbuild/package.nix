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
    sha256 = "sha256-gYIYd3J4mCJJU0yJ+2xL/5URKo+M8T2Q9CWLbxQ2rtQ=";
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
