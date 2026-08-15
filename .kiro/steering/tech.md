# Technology Stack

## Architecture

Nix flake exposing a flat `packages.<system>` attrset. Each package is defined in its own directory under `pkgs/<first-letter>/<name>/package.nix` and wired through a central `default.nix`.

## Core Technologies

- **Language**: Nix (flake-based)
- **Nixpkgs branch**: nixos-unstable (follows upstream)
- **Build helpers**: flake-utils, pyproject-nix, uv2nix, npm-lockfile-fix

## Packaging Patterns

### Pre-built binaries (most common)
```nix
{ lib, stdenv, fetchurl, autoPatchelfHook, glibc, ... }:
stdenv.mkDerivation {
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ glibc stdenv.cc.cc.lib ];
  # unpack + installPhase only, no buildPhase
}
```

### AppImage wrapping
```nix
{ lib, appimageTools, fetchurl }:
appimageTools.wrapType2 { inherit pname version src; }
```

### Python applications
```nix
python.buildPythonApplication {
  pyproject = true;
  # pythonRelaxDeps / pythonRemoveDeps for version pin conflicts
  # patches for NixOS-specific fixes
}
```

### .deb extraction
```nix
{ dpkg, autoPatchelfHook, ... }:
stdenv.mkDerivation {
  nativeBuildInputs = [ dpkg autoPatchelfHook ];
  unpackPhase = "dpkg-deb -x $src .";
}
```

### Upstream overrides (in default.nix)
```nix
pkgs.somePackage.overrideAttrs (prev: { /* modifications */ });
```

## Development Commands

```bash
# Build a specific package
nix build .#<package-name>

# Build all packages (check for breakage)
nix flake check

# Enter dev shell
nix develop

# Test a package interactively
nix shell .#<package-name>
```

## Key Technical Decisions

- **Flat namespace**: All packages exported at top level (no nested attrsets)
- **Single default.nix**: Central registry wiring callPackage to each package.nix
- **Multi-arch via attrset**: `srcs = { x86_64-linux = ...; aarch64-linux = ...; };`
- **Patches as files**: Custom patches live alongside package.nix in the same directory
- **No tests by default**: `doCheck = false` for most packages (upstream tests not relevant to packaging)

---
_Document standards and patterns, not every dependency_
