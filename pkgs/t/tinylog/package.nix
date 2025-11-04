{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  with_pkgconf? false,
}:

let
  meta =  with lib; {
    description = "Tinylog is a lightweight C-language high performance log component for UNIX environment, It is high performance, asynchronized, thread-safe and process-safe log library for C/C++.";
    homepage = "https://github.com/pymumu/tinylog";
    license = lib.licenses.mit;
#    maintainers = with lib.maintainers; [ matthiasbeyer ];
#    mainProgram = "zlog-chk-conf";
    platforms = lib.platforms.unix;
  };
  pname = "tlog";
  version = "1.0.0";
in
stdenv.mkDerivation (finalAttrs: {
  pname = pname;
  version = version;
                 
  src = fetchFromGitHub {
    owner = "shen390s";
    repo = "tinylog";
    rev = "master";
    hash = "sha256-EvLoi4Yew7hE8wnogh7nJxoDsZbjphsHCCxuWzbWysA=";
  };

  nativeBuildInputs = [ cmake ];

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    cat >$out/lib/pkgconfig/tinylog.pc <<EOF
    prefix=$out
    exec_prefix=\''${prefix}
    libdir=$out/lib
    includedir=\''${prefix}/include

    Name: ${pname}
    Description: ${meta.description}
    Version: ${version}
    Libs: -L\''${libdir} -ltlog
    Cflags: -I\''${includedir}
    EOF
  '';
  
  inherit meta;
})
