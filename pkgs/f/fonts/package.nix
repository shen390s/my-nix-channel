{
  lib,
  stdenv,
#  fetchFromGitea,
#  fetchFromGitHub,
#  fetchgit,
  pkgs? import <nixpkgs> {},
  pkg-config,
}:

let
  meta =  with lib; {
    description = "Some true type fonts";
    homepage = "https://github.com/shen390s/my-ttf-fonts";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
  pname = "my-ttf-fonts";
  version = "1.0";
  mysource = pkgs.runCommand "download-fonts" {
    nativeBuiltInputs = [ pkgs.curl ];
    outputHash = "sha256-JMWxG0lCkzXhuBoBtEk8N0g6qrLRJo0WGki9A+yTbhU=";
    outputHashAlgo = "sha256";
    outputHashMode = "flat";
  } ''
     ${pkgs.curl}/bin/curl --output $out  \
          --location \
          --max-redirs 20 \
          --retry 3  \
          --disable-epsv \
          --cookie-jar cookies \
          --insecure \
          --user-agent curl/8.17.0  -C - --fail \
          https://gitee.com/shen390s/my-ttf-fonts/archive/refs/tags/v1.0.tar.gz
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = pname;
  version = version;
                 
  src = mysource;
  
  unpackPhase = ''
     tar -zxvf $src
  '';
  
  installPhase = ''
     mkdir -p $out/share/fonts/truetype
     _fontdir="${pname}-v${version}"
     if [ -d $_fontdir/fonts/truetype ]; then
        ls $_fontdir/fonts/truetype/*
        cp -r $_fontdir/fonts/truetype/*.ttf $out/share/fonts/truetype/
	      cp -r $_fontdir/fonts/truetype/*.ttc $out/share/fonts/truetype/
     else
        echo "No fonts found in $_fontdir/fonts/truetype"
        exit 0
     fi
  '';
  
  inherit meta;
})
