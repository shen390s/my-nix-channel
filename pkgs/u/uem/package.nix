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
    hash = "sha256-lfw4WLRyKv2tJbLuc21UoKZueyWgFkxcgVXTKVLT5ow=";
  };

  buildInputs = with pkgs; [ 
    roswell 
    patchelf
    sbcl
    zstd
  ];

  propagatedBuildInputs = with pkgs; [
    zstd
  ];

  doCheck = true; 
  dontStrip = true;

  configurePhase = ''
    export ROSWELL_HOME=$PWD/.roswell
    export HOME=$TMP
    ros setup
    ros use sbcl-bin/system
  '';
  
  buildPhase = ''
     set -e
     cat >$ROSWELL_HOME/init.lisp <<EOF
       (ros:ensure-asdf)
       (push (uiop:ensure-directory-pathname "$src/") asdf:*central-registry*)
     EOF
     cp -Rf $src/roswell .
     ros build  roswell/uem.ros 
  '';          

  installPhase = ''
     mkdir -p $out/bin
     cp roswell/uem $out/bin
     cp -Rf $src/modules $out
  '';
})
