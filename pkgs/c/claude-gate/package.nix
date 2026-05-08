# claude-gate
{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  ...
}:

stdenv.mkDerivation {
  pname = "claude-gate";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "shen390s";
    repo = "claude-gate";
    rev = "master";
    sha256 = "sha256-StvSYsWLbGQCXpzlOaXjd7VRn/8l+u3CVIiK1nyVGqU=";
  };

  nativeBuildInputs = [ 
    pkgs.go
    pkgs.gcc
    pkgs.gnumake   
  ];

  env = {
    GOPROXY = "https://goproxy.cn";
  };

  buildPhase = ''
    HOME=$TMPDIR
    GOCACHE=$TMPDIR/gocache
    GOPATH=$TMPDIR/go
    export HOME GOCACHE GOPATH
    make build
  '';

  installPhase = ''
     mkdir -p $out/bin
     cp claude-gate $out/bin
  '';
}
