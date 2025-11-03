{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  with_pkgconf? false,
}:

let
  meta =  with lib; {
    description = "Reliable, high-performance, thread safe, flexible, clear-model, pure C logging library";
    homepage = "https://hardysimpson.github.io/zlog/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "zlog-chk-conf";
    platforms = lib.platforms.unix;
  };
  pname = "zlog";
  version = "1.2.18";
in
stdenv.mkDerivation (finalAttrs: {
  pname = pname;
  version = version;
                 
  src = fetchFromGitHub {
    owner = "HardySimpson";
    repo = "zlog";
    tag = finalAttrs.version;
    hash = "sha256-79yyOGKgqUR1KI2+ngZd7jfVcz4Dw1IxaYfBJyjsxYc=";
  };

  nativeBuildInputs = [ cmake ];

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    cat >$out/lib/pkgconfig/zlog.pc <<EOF
    prefix=$out
    exec_prefix=\''${prefix}
    libdir=$out/lib
    includedir=\''${prefix}/include

    Name: ${pname}
    Description: ${meta.description}
    Version: ${version}
    Libs: -L\''${libdir} -lzlog
    Cflags: -I\''${includedir}
    EOF
  '';
  
  inherit meta;
})
