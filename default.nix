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
  libcello_debug = pkgs.libcello.overrideAttrs (prevAttrs: {
    separateDebugInfo = true;
    postInstall = ''
         mkdir -p $out/lib/pkgconfig
         cat >$out/lib/pkgconfig/libcello.pc <<EOF
         prefix=$out
         exec_prefix=\''${prefix}
         libdir=$out/lib
         includedir=$out/include

         Name: ${prevAttrs.pname}
         Version: ${prevAttrs.version}
         Description: ${prevAttrs.meta.description}
         Libs: -L\''${libdir} -lCello
         Cflags: -I\''${includedir}
         EOF
    '';
  });
  packcc_main = pkgs.packcc.overrideAttrs (prevAttrs: {
    version = "3.0.0";
    src = fetchFromGitHub {
      owner = "arithy";
      repo = "packcc";
      rev = "main";
      hash = "sha256-zkrpPGLylgPpV1iyXosVbsbn2qt8/+WnBeK/w1WtwBk=";
    };

    nativeBuildInputs = [
      pkgs.cmake
      pkgs.gnumake
    ];
    
    preBuild = ''
      echo using ${if stdenv.cc.isGNU then
         "gcc"
      else if stdenv.cc.isClang then
         "clang"
      else
        throw "Unknown compiler"
    }
    '';

    buildPhase = ''
       cmake $src -DCMAKE_INSTALL_PREFIX=$out
       cmake --build .
    '';

    installPhase = ''
       cmake --install .
    '';
    
  });
  uem = callPackage ./pkgs/u/uem/package.nix {
    pkgs = pkgs;
  };
  cetcd = callPackage ./pkgs/c/cetcd/package.nix {};
  struct2json = callPackage ./pkgs/s/struct2json/package.nix {
    pkgs = pkgs;
  };
  my-ttf-fonts = callPackage ./pkgs/f/fonts/package.nix {};
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
  libcello_debug = libcello_debug;
  packcc = packcc_main;
  struct2json = struct2json;
  my-ttf-fonts = my-ttf-fonts;
}
