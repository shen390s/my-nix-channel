# Product Overview

Personal Nix package channel providing packages not available in nixpkgs or requiring custom patches/configurations. Consumed as a flake input by the user's NixOS infrastructure flake and personal profiles.

## Core Capabilities

- Package binaries (pre-built ELF, AppImage, .deb) with `autoPatchelfHook` for NixOS compatibility
- Build Python applications via `buildPythonApplication` with dependency management (uv2nix, pyproject-nix)
- Patch upstream packages (e.g., timeout adjustments, permission fixes) without forking
- Provide platform-specific builds (x86_64-linux, aarch64-linux where applicable)

## Target Use Cases

- AI/dev tooling not in nixpkgs (kiro-cli, codegraph, claude-agent-acp, craft-agents, hermes-agent)
- Infrastructure utilities (gost-ctl, norouter, xbuild)
- Desktop apps distributed as .deb/AppImage (solomd, tla-toolbox)
- Custom-patched versions of upstream packages (unity-test with color, packcc main branch)

## Value Proposition

Single flake input providing all non-nixpkgs packages needed across the user's machines, with reproducible builds and custom patches tracked in version control.

---
_Focus on patterns and purpose, not exhaustive feature lists_
