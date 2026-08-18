{
  lib,
  stdenv,
  makeWrapper,
  callPackage,
  fetchFromGitHub,
  python312,
  electron,
  ripgrep,
  git,
  openssh,
  ffmpeg,
  wl-clipboard,
  xclip,
  cage,
  uv2nix,
  pyproject-nix,
  pyproject-build-systems,
  npm-lockfile-fix,
}:
let
  rev = "7e05e9080b2e46cd35e6f0caa016360301258823";

  src = fetchFromGitHub {
    owner = "NousResearch";
    repo = "hermes-agent";
    inherit rev;
    hash = "sha256-myGU+PMwaJNTUYIPUp4BmxUAfryurM1QOKq3CgjQ4K8=";
  };

  # tirith is an optional security scanner that auto-downloads itself at runtime
  # if not found on PATH; provide a stub so the nix package builds cleanly.
  tirith = stdenv.mkDerivation {
    pname = "tirith-stub";
    version = "0";
    dontUnpack = true;
    installPhase = "mkdir -p $out/bin";
  };
in
  callPackage "${src}/nix/hermes-agent.nix" {
    inherit
      lib
      stdenv
      makeWrapper
      callPackage
      python312
      electron
      ripgrep
      git
      openssh
      ffmpeg
      wl-clipboard
      xclip
      cage
      tirith
      uv2nix
      pyproject-nix
      pyproject-build-systems
      npm-lockfile-fix
      ;
  }
