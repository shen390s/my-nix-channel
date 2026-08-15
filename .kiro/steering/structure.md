# Project Structure

## Organization Philosophy

Alphabetical by first letter, then by package name. Each package is self-contained in its own directory with all sources (package.nix, patches, assets) co-located.

## Directory Patterns

### Package directory
**Location**: `pkgs/<first-letter>/<package-name>/`  
**Purpose**: Self-contained package definition  
**Contents**: `package.nix` (required), plus any patches (`.patch`) or bundled assets (`.tar.gz`, etc.)  
**Example**: `pkgs/k/kiro-crew/` contains `package.nix`, `fix-copytree-perms.patch`, `increase-timeouts.patch`, `dashboard.tar.gz`

### Root flake
**Location**: `flake.nix`  
**Purpose**: Declare inputs and wire `default.nix` into flake outputs  
**Pattern**: Passes flake inputs (nixpkgs, uv2nix, etc.) to `default.nix`

### Package registry
**Location**: `default.nix`  
**Purpose**: Central file that `callPackage`s every package.nix and exports the final attrset  
**Pattern**: All packages defined in `let` block, exported in final `{ ... }` attrset

## Naming Conventions

- **Directories**: lowercase, matching package `pname` (e.g., `kiro-cli`, `codegraph`, `struct2json`)
- **Files**: always `package.nix` (never `default.nix` inside package dirs)
- **Patches**: descriptive kebab-case (e.g., `fix-copytree-perms.patch`, `increase-timeouts.patch`)
- **Package names** (`pname`): match upstream naming (kebab-case preferred)

## Adding a New Package

1. Create `pkgs/<first-letter>/<name>/package.nix`
2. Add `callPackage` line in `default.nix` `let` block
3. Export in the final attrset at bottom of `default.nix`
4. `git add` the new files (required for flake to see them)
5. `nix build .#<name>` to verify

## Code Organization Principles

- **One package per directory** — never multiple packages in one dir
- **Co-locate patches** — patches live next to their package.nix
- **Minimal inputs** — only pass what the package actually needs to `callPackage`
- **No default.nix inside packages** — the file is always named `package.nix` to avoid confusion with the root `default.nix`

---
_Document patterns, not file trees. New files following patterns shouldn't require updates_
