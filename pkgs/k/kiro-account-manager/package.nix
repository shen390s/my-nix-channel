{ lib
, rustPlatform
, fetchFromGitHub
, buildNpmPackage
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
  version = "1.8.7";

  src = fetchFromGitHub {
    owner = "hj01857655";
    repo = "kiro-account-manager";
    rev = "v1.8.7";
    hash = "sha256-C97sXXjXVtroB1gR1SSr9eftarEMCEIdl07QbLh1GWc=";
  };

  frontend = buildNpmPackage {
    pname = "${pname}-frontend";
    inherit version src;

    npmDepsHash = "sha256-BI0lxemB7qcu1o7bp6kOZrl1/YTVPa8jNUFpZIMZB1I=";

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };

in rustPlatform.buildRustPackage {
  inherit pname version src;

  sourceRoot = "${src.name}/src-tauri";

  cargoHash = "sha256-C6+0Z7Mj9YuGInNTO9gyzDIrobaOWSHeNm6rEVveifY=";

  postPatch = ''
    substituteInPlace tauri.conf.json \
      --replace-fail '"frontendDist": "../dist"' '"frontendDist": "${frontend}"'
    substituteInPlace .cargo/config.toml \
      --replace-fail '"-C", "link-arg=-fuse-ld=lld"' ""
  '';

  nativeBuildInputs = [ pkg-config ];

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

  meta = {
    description = "Kiro IDE account manager with multi-account switching and quota monitoring";
    homepage = "https://github.com/hj01857655/kiro-account-manager";
    license = lib.licenses.cc-by-nc-sa-40;
    mainProgram = "kiro-account-manager";
    platforms = lib.platforms.linux;
  };
}
