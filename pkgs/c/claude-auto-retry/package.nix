{ lib, stdenv, fetchFromGitHub, nodejs, makeWrapper, tmux }:

stdenv.mkDerivation rec {
  pname = "claude-auto-retry";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "shen390s";
    repo = "claude-auto-retry";
    rev = "master";
    hash = "sha256-4G9K/poQkWh8snsEK41VNySe79i1lCtHMsu7Xui1+IM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{lib/claude-auto-retry,bin}
    cp -r bin src package.json $out/lib/claude-auto-retry/
    makeWrapper ${nodejs}/bin/node $out/bin/claude-auto-retry \
      --add-flags "$out/lib/claude-auto-retry/bin/cli.js" \
      --prefix PATH : ${lib.makeBinPath [ tmux ]}
    runHook postInstall
  '';

  meta = {
    description = "Automatically retry Claude Code sessions when hitting rate limits";
    homepage = "https://github.com/shen390s/claude-auto-retry";
    license = lib.licenses.mit;
    mainProgram = "claude-auto-retry";
    platforms = lib.platforms.unix;
  };
}
