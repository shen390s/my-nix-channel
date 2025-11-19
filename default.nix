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
  tinylog = callPackage ./pkgs/t/tinylog/package.nix {};
  unity_test_with_color = pkgs.unity-test.overrideAttrs {
    env.NIX_CFLAGS_COMPILE = "-DUNITY_OUTPUT_COLOR=1"; 
  }; 
  uem = callPackage ./pkgs/u/uem/package.nix {
    pkgs = pkgs;
  };
  cetcd = callPackage ./pkgs/c/cetcd/package.nix {};
in
{
  xbuild = xbuild;
  capnpc = capnpc;
  cedro  = cedro;
  zlog_with_pkgconf = zlog_with_pkgconf;
  tinylog = tinylog;
  unity_test_with_color = unity_test_with_color;
  uem = uem;
  cetcd = cetcd;
}
