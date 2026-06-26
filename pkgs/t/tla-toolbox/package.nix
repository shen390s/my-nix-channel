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
    find $out/lib/tla-toolbox -type f -exec sh -c 'file "$1" | grep -q "ELF" && chmod +x "$1"' _ {} \;

    # Use system JDK instead of bundled JRE
    cat > $out/lib/tla-toolbox/toolbox.ini <<EOF
    -startup
    plugins/org.eclipse.equinox.launcher_1.6.500.v20230717-2134.jar
    --launcher.library
    plugins/org.eclipse.equinox.launcher.gtk.linux.x86_64_1.2.700.v20221108-1024
    --launcher.defaultAction
    openFile
    -name
    TLA+ Toolbox
    --launcher.GTK_version
    3
    -vm
    ${jdk17}/bin/java
    -vmargs
    -XX:+IgnoreUnrecognizedVMOptions
    -Xmx1024m
    -XX:+UseParallelGC
    -Dorg.eclipse.equinox.http.jetty.http.port=10996
    -Dosgi.splashPath=platform:/base/
    -Dosgi.requiredJavaVersion=17.0
    -Dosgi.instance.area.default=@user.home/.tlaplus/
    -Dosgi.clean=true
    EOF
    # Remove leading whitespace from heredoc
    sed -i 's/^    //' $out/lib/tla-toolbox/toolbox.ini

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
