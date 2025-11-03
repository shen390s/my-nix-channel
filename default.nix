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
  zlog_with_pkgconf = callPackage ./pkgs/z/zlog/package.nix {
    with_pkgconf = true;
  };
in
{
  xbuild = xbuild;
  capnpc = capnpc;
  cedro  = cedro;
  zlog_with_pkgconf = zlog_with_pkgconf;
}
