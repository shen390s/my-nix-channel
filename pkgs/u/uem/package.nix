{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkgs,
}:

let
  pname = "uem";
  version = "0.1";
  meta = {
    description = "Universal Emacs Manager";
    homepage = "https://github.com/shen390s/uem";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.i01011001 ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = pname;
  version = version;
  
  src = fetchFromGitHub {
    owner = "shen390s";
    repo = "uem";
    rev = "develop";
    hash = "sha256-WLQak+5dbD4Zo3EgnW5YVhj5tNPJlkXYdd4lNLzRlq0=";
  };

  nativeBuildInputs = [ pkgs.roswell ];
  doCheck = true;

  configurePhase = ''
     mkdir -p .roswell
     cat >.roswell/init.lisp <<EOF
     (format nil "Hell,world~%")
     ;;(push "$src" asdf:*central-registry*)
     EOF
  '';
  
  buildPhase = ''
     set +e
     set -x
     cat .roswell/init.lisp
     ros setup
     # find /build/.roswell
     # echo running
     sh -x ros version
     find .
     find /build/source
     # ros build $src/roswell/uem.ros
     mkdir -p $out
     cp .roswell/init.lisp $out
  '';          
})
