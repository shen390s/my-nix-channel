{ lib, stdenv, fetchurl, autoPatchelfHook, glibc, zlib, xorg ? null }:

let
  pname = "kiro-cli";
  version = "2.19.0";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://prod.download.cli.kiro.dev/stable/${version}/kirocli-x86_64-linux.tar.gz";
      hash = "sha256-+8PU8z1fE1OUZ+1DWjIorjkKOjHB8k2eqjnN5oe0kWw=";
    };
    aarch64-linux = fetchurl {
      url = "https://prod.download.cli.kiro.dev/stable/${version}/kirocli-aarch64-linux.tar.gz";
      hash = "sha256-0B+ngW1msSJZi1BdgCrDYsvCYp1i4F8erPmyuwHjNXs=";
    };
  };
in stdenv.mkDerivation {
  inherit pname version;

  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    glibc
    stdenv.cc.cc.lib
    zlib
  ] ++ lib.optionals (xorg != null) [
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
  ];

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib/kiro-cli

    # The tarball extracts to a kirocli/ directory with binaries under bin/
    cp -r kirocli/. $out/lib/kiro-cli/

    # Symlink the binaries from the nested bin/ directory
    for bin in kiro-cli kiro-cli-chat kiro-cli-term; do
      if [ -f "$out/lib/kiro-cli/bin/$bin" ]; then
        chmod +x "$out/lib/kiro-cli/bin/$bin"
        ln -s "$out/lib/kiro-cli/bin/$bin" "$out/bin/$bin"
      fi
    done

    # Also provide 'kiro' convenience alias
    ln -s "$out/bin/kiro-cli" "$out/bin/kiro"

    runHook postInstall
  '';

  # Skip stripping pre-built binaries
  dontStrip = true;

  meta = {
    description = "Kiro CLI - agentic AI coding assistant for the terminal";
    homepage = "https://kiro.dev/cli/";
    license = lib.licenses.unfree;
    mainProgram = "kiro-cli";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
