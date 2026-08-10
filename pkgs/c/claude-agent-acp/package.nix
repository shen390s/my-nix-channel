{ lib, buildNpmPackage, fetchFromGitHub, nodejs_22, makeWrapper }:

buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.66.0";

  src = fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-B6oB0xrDHFm46YfgTc/VlxPjHhCdSNlriq1zGe6XyU4=";
  };

  npmDepsHash = "sha256-7c9+Q+HkoUeL38EzEbu+KePA/aN+If9tGr7C/lWluhU=";

  nodejs = nodejs_22;

  nativeBuildInputs = [ makeWrapper ];

  npmBuildScript = "build";

  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{lib/claude-agent-acp,bin}
    cp -r dist package.json node_modules $out/lib/claude-agent-acp/
    makeWrapper ${nodejs}/bin/node $out/bin/claude-agent-acp \
      --add-flags "$out/lib/claude-agent-acp/dist/index.js"
    runHook postInstall
  '';

  meta = {
    description = "ACP adapter for the Claude Agent SDK - use Claude Agent SDK from ACP-compatible clients";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
    mainProgram = "claude-agent-acp";
    platforms = lib.platforms.unix;
  };
}
