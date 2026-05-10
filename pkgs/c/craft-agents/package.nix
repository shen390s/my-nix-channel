{ lib, appimageTools, fetchurl }:

let
  pname = "craft-agents";
  version = "0.9.2";

  src = fetchurl {
    url = "https://github.com/craft-ai-agents/craft-agents-oss/releases/download/v${version}/Craft-Agents-${version}-linux-x64.AppImage";
    hash = "sha256-wEApsnpuiRgEnptcNTuSyz7Q4C1eCtfy205av+FqfPE=";
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
