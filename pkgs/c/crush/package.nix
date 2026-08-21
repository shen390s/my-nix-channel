{ lib, stdenv, fetchurl }:

let
  pname = "crush";
  version = "0.90.0";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/charmbracelet/crush/releases/download/v${version}/crush_${version}_Linux_x86_64.tar.gz";
      hash = "sha256-Tuu5zho2VVYLrgPGS+vMVG9rJLqfnr0ejqhEuMOzfqA=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/charmbracelet/crush/releases/download/v${version}/crush_${version}_Linux_arm64.tar.gz";
      hash = "sha256-WwgwHJ8RJ0JzUKwRuk+piClFPDjh2T5w7vjvDp1tu/E=";
    };
  };
in stdenv.mkDerivation {
  inherit pname version;

  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 crush_${version}_Linux_*/crush $out/bin/crush

    # Shell completions
    install -Dm644 crush_${version}_Linux_*/completions/crush.bash $out/share/bash-completion/completions/crush
    install -Dm644 crush_${version}_Linux_*/completions/crush.zsh $out/share/zsh/site-functions/_crush
    install -Dm644 crush_${version}_Linux_*/completions/crush.fish $out/share/fish/vendor_completions.d/crush.fish

    # Manpage
    install -Dm644 crush_${version}_Linux_*/manpages/crush.1.gz $out/share/man/man1/crush.1.gz

    runHook postInstall
  '';

  meta = {
    description = "Glamourous agentic coding for all";
    homepage = "https://github.com/charmbracelet/crush";
    license = lib.licenses.fsl11Mit;
    mainProgram = "crush";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
