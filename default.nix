{pkgs,...}:
{
  xbuild = pkgs.callPackage ./pkgs/x/xbuild/package.nix {};
  cedro = pkgs.callPackage ./pkgs/c/cedro/package.nix {};
}
