{pkgs,...}:
with pkgs;
let
  cedro = callPackage ./pkgs/c/cedro/package.nix {};
  capnpc = callPackage ./pkgs/c/capnpc/package.nix {};
  xbuild = callPackage ./pkgs/x/xbuild/package.nix {
    pkgs = pkgs;
    cedro = cedro;
    capnpc = capnpc;
  };
in
{
  xbuild = xbuild;
  capnpc = capnpc;
  cedro  = cedro;
}
