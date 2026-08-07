{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  webkitgtk_4_1,
  gtk3,
  gdk-pixbuf,
  cairo,
  glib,
  dbus,
  libsoup_3,
  zlib,
  xz,
  openssl,
  libsecret,
}:

stdenv.mkDerivation rec {
  pname = "solomd";
  version = "4.11.9";

  src = fetchurl {
    url = "https://github.com/zhitongblog/solomd/releases/download/v${version}/SoloMD_${version}_amd64.deb";
    hash = "sha256-zTVgr5PXc5U/qLhN38YDlhUBiBV9Wion1vjS96liwEI=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
    gdk-pixbuf
    cairo
    glib
    dbus
    libsoup_3
    zlib
    xz
    openssl
    libsecret
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/solomd $out/share

    # Install main binary and MCP server
    install -m755 usr/bin/SoloMD $out/lib/solomd/SoloMD
    install -m755 usr/bin/solomd-mcp $out/bin/solomd-mcp

    # Install resources
    cp -r usr/lib/SoloMD/* $out/lib/solomd/ 2>/dev/null || true

    # Install desktop file and icons
    cp -r usr/share/* $out/share/

    # Fix desktop file
    substituteInPlace $out/share/applications/SoloMD.desktop \
      --replace-warn 'Exec=SoloMD' "Exec=$out/bin/solomd"

    # Create wrapper
    makeWrapper $out/lib/solomd/SoloMD $out/bin/solomd \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"

    runHook postInstall
  '';

  meta = {
    description = "A local-first markdown editor with bundled MCP server and AI agent surface (Tauri 2 + Vue 3)";
    homepage = "https://github.com/zhitongblog/solomd";
    license = lib.licenses.mit;
    mainProgram = "solomd";
    platforms = [ "x86_64-linux" ];
  };
}
