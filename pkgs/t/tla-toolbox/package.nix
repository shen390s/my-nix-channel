{ lib, stdenv, fetchzip, autoPatchelfHook, makeWrapper,
  gtk3, glib, webkitgtk_4_1, libx11, libxtst, libsecret, alsa-lib, jdk17 }:

let
  pname = "tla-toolbox";
  version = "1.8.0";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchzip {
    url = "https://github.com/tlaplus/tlaplus/releases/download/v${version}/TLAToolbox-${version}-linux.gtk.x86_64.zip";
    hash = "sha256-cXECx4GY/79F41UlBfPURcBQHhZuc1Sv5TkNsZ32RKQ=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [
    gtk3 glib webkitgtk_4_1
    libx11 libxtst
    libsecret alsa-lib
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{lib/tla-toolbox,bin}
    cp -r --no-preserve=mode . $out/lib/tla-toolbox/
    chmod +x $out/lib/tla-toolbox/toolbox
    makeWrapper $out/lib/tla-toolbox/toolbox $out/bin/tla-toolbox \
      --prefix PATH : ${jdk17}/bin \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ gtk3 glib webkitgtk_4_1 libx11 libxtst libsecret ]}
    runHook postInstall
  '';

  meta = {
    description = "IDE for the TLA+ tools (TLC model checker, PlusCal translator, TLAPS proof system)";
    homepage = "https://github.com/tlaplus/tlaplus";
    license = lib.licenses.mit;
    mainProgram = "tla-toolbox";
    platforms = [ "x86_64-linux" ];
  };
}
