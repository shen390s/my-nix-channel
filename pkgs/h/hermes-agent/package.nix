{
  lib,
  stdenv,
  makeWrapper,
  callPackage,
  fetchFromGitHub,
  python312,
  nodejs_22,
  ripgrep,
  git,
  openssh,
  ffmpeg,
  uv2nix,
  pyproject-nix,
  pyproject-build-systems,
  npm-lockfile-fix,
}:
let
  rev = "96dc2726232fc02c836b29968550d7dc5af03e36";

  src = fetchFromGitHub {
    owner = "NousResearch";
    repo = "hermes-agent";
    inherit rev;
    hash = "sha256-pyqKp9gQLhHz0F8Gsw482CB6M8lRF5mW+Jvxj8sYP7k=";
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
      python312
      nodejs_22
      ripgrep
      git
      openssh
      ffmpeg
      tirith
      uv2nix
      pyproject-nix
      pyproject-build-systems
      npm-lockfile-fix
      ;
  }
