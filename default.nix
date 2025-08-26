{pkgs,...}:
with pkgs;
{
  xbuild = callPackage ./pkgs/x/xbuild/package.nix {};
  cedro = callPackage ./pkgs/c/cedro/package.nix {};
  capnpc = callPackage ./pkgs/c/capnpc/package.nix {};
}
