{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

let
  pname = "unity-test";
  version = "2.6.1";
  meta = {
    description = "Unity Unit Testing Framework";
    homepage = "https://www.throwtheswitch.org/unity";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.i01011001 ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = pname;
  version = version;
  
  src = fetchFromGitHub {
    owner = "ThrowTheSwitch";
    repo = "Unity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g0ubq7RxGQmL1R6vz9RIGJpVWYsgrZhsTWSrL1ySEug=";
  };

  nativeBuildInputs = [ cmake ];
  # makeFlags = [ "UNITY_OUTPUT_COLOR=1" ];
  env.NIX_CFLAGS_COMPILE = "-DUNITY_OUTPUT_COLOR=1";
  doCheck = true;

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    cat >$out/lib/pkgconfig/unity.pc <<EOF
    prefix=$out
    exec_prefix=\''${prefix}
    libdir=$out/lib
    includedir=\''${prefix}/include

    Name: ${pname}
    Description: ${meta.description}
    Version: ${version}
    Libs: -L\''${libdir} -lunity
    Cflags: -I\''${includedir}
    EOF
  '';
  

})
