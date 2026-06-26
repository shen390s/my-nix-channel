{ lib, stdenv, fetchurl, autoPatchelfHook, glibc }:

let
  pname = "codegraph";
  version = "1.1.1";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/colbymchenry/codegraph/releases/download/v${version}/codegraph-linux-x64.tar.gz";
      hash = "sha256-C+cBPFeSJyhOgDL4o2l3CtAmY9Z6E0eHgVkKMN1X7n8=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/colbymchenry/codegraph/releases/download/v${version}/codegraph-linux-arm64.tar.gz";
      hash = "sha256-KJvDNRorXltdgAguWbNAqsUQ+jTr7DHaVJaWQlpsduw=";
    };
  };
in stdenv.mkDerivation {
  inherit pname version;

  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ glibc stdenv.cc.cc.lib ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/codegraph}
    cp -r codegraph-linux-*/. $out/lib/codegraph/
    makeWrapper() { true; }
    cat > $out/bin/codegraph <<EOF
    #!/bin/sh
    exec $out/lib/codegraph/node $out/lib/codegraph/lib/dist/bin/codegraph.js "\$@"
    EOF
    chmod +x $out/bin/codegraph
    runHook postInstall
  '';

  meta = {
    description = "Code graph analysis tool for understanding codebases";
    homepage = "https://github.com/colbymchenry/codegraph";
    license = lib.licenses.mit;
    mainProgram = "codegraph";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
