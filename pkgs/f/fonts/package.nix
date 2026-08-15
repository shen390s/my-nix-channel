{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "my-ttf-fonts";
  version = "1.0";

  src = fetchurl {
    url = "https://vcs.shenrs.eu/rshen/fonts/archive/v${version}.tar.gz";
    hash = "sha256-X3jlNjHdVugQ2Loj16juEi+TLlirLk3APlW9Oc8ZRZk=";
  };

  unpackPhase = ''
    tar -zxf $src
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    _fontdir="fonts"
    if [ -d $_fontdir/fonts/truetype ]; then
      cp -r $_fontdir/fonts/truetype/*.ttf $out/share/fonts/truetype/ 2>/dev/null || true
      cp -r $_fontdir/fonts/truetype/*.ttc $out/share/fonts/truetype/ 2>/dev/null || true
    fi
  '';

  meta = with lib; {
    description = "Some true type fonts";
    homepage = "https://vcs.shenrs.eu/rshen/fonts";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
