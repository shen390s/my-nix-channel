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
  rev = "532b7ed408b204f0d6765061b6e52072b20e0d22";

  src = fetchFromGitHub {
    owner = "NousResearch";
    repo = "hermes-agent";
    inherit rev;
    hash = "sha256-Gyigd+xOXErW3MnN8/2yk5w51px/elOLs2WpL/XkDpc=";
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
