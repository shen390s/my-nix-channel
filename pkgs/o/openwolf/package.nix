{ lib, buildNpmPackage, fetchurl }:

buildNpmPackage rec {
  pname = "openwolf";
  version = "2.0.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/openwolf/-/openwolf-${version}.tgz";
    hash = "sha256-qmCNl2euE8DToMGUSoFNE/in+7Bfr9FrN9euR5FCNM0=";
  };

  sourceRoot = ".";
  unpackPhase = ''
    mkdir -p $sourceRoot
    tar xzf $src --strip-components=1 -C $sourceRoot
  '';

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    cp ${./package.json} package.json
  '';

  npmDepsHash = "sha256-oK5fJIHzpP+oeeFB7EeCH3CjQgyoVv4FyYK7qaZ16N4=";

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/openwolf
    cp -r dist src/templates package.json node_modules $out/lib/node_modules/openwolf/

    mkdir -p $out/bin
    ln -s $out/lib/node_modules/openwolf/dist/bin/openwolf.js $out/bin/openwolf
    chmod +x $out/lib/node_modules/openwolf/dist/bin/openwolf.js

    runHook postInstall
  '';

  meta = {
    description = "Context management middleware for AI coding assistants - the second brain for Claude Code and others";
    homepage = "https://github.com/cytostack/openwolf";
    license = lib.licenses.agpl3Only;
    mainProgram = "openwolf";
    platforms = lib.platforms.linux;
  };
}
