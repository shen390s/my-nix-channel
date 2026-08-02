{ lib, appimageTools, fetchurl }:

let
  pname = "craft-agents";
  version = "0.11.2";

  src = fetchurl {
    url = "https://github.com/craft-ai-agents/craft-agents-oss/releases/download/v${version}/Craft-Agents-${version}-linux-x64.AppImage";
    hash = "sha256-oNKZwnqI93elV2G4R941ZDc7rNBnt0M2QoCb2mThxnc=";
  };
in appimageTools.wrapType2 {
  inherit pname version src;

  meta = {
    description = "Agent-native AI assistant built on Claude and Pi SDKs";
    homepage = "https://github.com/craft-ai-agents/craft-agents-oss";
    license = lib.licenses.asl20;
    mainProgram = "craft-agents";
    platforms = [ "x86_64-linux" ];
  };
}
