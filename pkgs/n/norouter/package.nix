{ stdenvNoCC, lib, fetchurl, autoPatchelfHook, zlib, openssl }:

stdenvNoCC.mkDerivation rec {
  pname = "norouter";
  version = "0.6.5";
  
  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${pname}-Linux-x86_64.tgz";
    hash = "sha256-kNAzGBuYLLHITGJAerH27kj8MjmxjII63ORym//rJEk=";
  }; 
  
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ zlib openssl ];  # Add required libraries
  
  dontUnpack = true;

  configurePhase = ''
    cat $src |gzip -dc |tar xf -
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp norouter $out/bin
  '';
}
