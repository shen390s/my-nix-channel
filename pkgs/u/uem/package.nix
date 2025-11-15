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

  buildInputs = with pkgs; [ 
    roswell 
    patchelf
    zstd
#    asdf-vm 
  ];

  propagatedBuildInputs = with pkgs; [
    zstd
  ];

  doCheck = true; 

  configurePhase = ''
    true
  '';
  
  buildPhase = ''
     set +e
     set -x
     export ROSWELL_HOME=$PWD/.roswell
     export HOME=$TMP
     ros setup
     ros use sbcl-bin/system
     export ASDF_CENTRAL_REGISTRY="$src"
     cat >$ROSWELL_HOME/init.lisp <<EOF
       (ros:ensure-asdf)
       (push (uiop:ensure-directory-pathname "$src/") asdf:*central-registry*)
     EOF
     cat $ROSWELL_HOME/init.lisp
     cp -Rf $src/roswell .
     ros build  roswell/uem.ros --disable-compression 
  '';          

  installPhase = ''
     mkdir -p $out/bin
     cp roswell/uem $out/bin
     SBCL_LIB_PATH=$(find $ROSWELL_HOME -type d -name "lib")
     ZSTD_LIB_PATH=${pkgs.zstd}/lib
     patchelf --set-rpath "$SBCL_LIB_PATH:$ZSTD_LIB_PATH:$out/bin" $out/bin/uem 
  '';
})
