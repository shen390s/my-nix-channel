{ lib, buildNpmPackage, fetchFromGitHub, nodejs_22, makeWrapper }:

buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.69.0";

  src = fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-x0k+5EhGx3y6Xd2rswTWMfYb0ZAYf5D+DaACr14uNMM=";
  };

  npmDepsHash = "sha256-Zr9aKUoIVheaFBMBmpZovsP0hWt0tqnxk/PMEjgP9HY=";

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
