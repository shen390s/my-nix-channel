{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
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
    tag = "v${finalAttrs.version}";
#    hash = "sha256-g0ubq7RxGQmL1R6vz9RIGJpVWYsgrZhsTWSrL1ySEug=";
  };

  nativeBuildInputs = [ roswell ];
  doCheck = true;

  buildPhase = ''
     ros build roswell/uem.ros
  '';          
})
