{ lib
, rustPlatform
, fetchFromGitHub
, buildNpmPackage
, makeWrapper
, pkg-config
, openssl
, glib
, gtk3
, libsoup_3
, webkitgtk_4_1
, dbus
, libayatana-appindicator
}:

let
  pname = "kiro-account-manager";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "hj01857655";
    repo = "kiro-account-manager";
    rev = "v1.9.2";
    hash = "sha256-lU+JL7iM7EWGs5NtJHIbXIeVI+eayi+8vuxCmoNWIXM=";
  };

  frontend = buildNpmPackage {
    pname = "${pname}-frontend";
    inherit version src;

    postPatch = ''
      cp ${./package-lock.json} package-lock.json
    '';

    npmDepsHash = "sha256-O+uNz/nN+5ZieKoKn82uT2jxG1bGAAdRrQ7PMHlsvHw=";

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };

in rustPlatform.buildRustPackage {
  inherit pname version src;

  sourceRoot = "${src.name}/src-tauri";

  cargoHash = "sha256-DkBHph3m6+M0t8qLDSwmTIPi7x4v8AQn0ccrNqBydPc=";

  postPatch = ''
    substituteInPlace tauri.conf.json \
      --replace-fail '"frontendDist": "../dist"' '"frontendDist": "${frontend}"'
    substituteInPlace .cargo/config.toml \
      --replace-fail '"-C", "link-arg=-fuse-ld=lld"' ""
  '';

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs = [
    openssl
    glib
    gtk3
    dbus
    libsoup_3
    webkitgtk_4_1
    libayatana-appindicator
  ];

  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/kiro-account-manager \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libayatana-appindicator ]}"
  '';

  meta = {
    description = "Kiro IDE account manager with multi-account switching and quota monitoring";
    homepage = "https://github.com/hj01857655/kiro-account-manager";
    license = lib.licenses.cc-by-nc-sa-40;
    mainProgram = "kiro-account-manager";
    platforms = lib.platforms.linux;
  };
}
