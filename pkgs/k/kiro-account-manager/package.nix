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
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "hj01857655";
    repo = "kiro-account-manager";
    rev = "2e2d4b09d3ad3b028dab719958707d9e19923261";
    hash = "sha256-d1TOjpzVNM+qKW12Ny6FeVfxdipY0ZUbs6Xg9TKeinI=";
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

  cargoHash = "sha256-GXoNqhwvK9A5zPt0Wb8+hJA+N1nm2DvOb2FfaurLq2Q=";

  postPatch = ''
    substituteInPlace tauri.conf.json \
      --replace-fail '"frontendDist": "../dist"' '"frontendDist": "${frontend}"'
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
