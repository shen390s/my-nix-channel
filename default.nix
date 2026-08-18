{pkgs, uv2nix ? null, pyproject-nix ? null, pyproject-build-systems ? null, npm-lockfile-fix-pkg ? null, ...}:
with pkgs;
let
  cedro = callPackage ./pkgs/c/cedro/package.nix {};
  capnpc = callPackage ./pkgs/c/capnpc/package.nix {};
  gost-ctl = callPackage ./pkgs/g/gost-ctl/package.nix {};
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
    version = "3.1.0";
    src = fetchFromGitHub {
      owner = "arithy";
      repo = "packcc";
      rev = "v3.1.0";
      hash = "sha256-vBRi9Pxcy6MhdrbZd13Xgel3w3qiIrU8F3rO1GFqSgE=";
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
       cmake --build .
    '';

    installPhase = ''
       cmake --install .
    '';
    
  });
  uem = callPackage ./pkgs/u/uem/package.nix {
    pkgs = pkgs;
  };
  deepseek-tui = callPackage ./pkgs/d/deepseek-tui/package.nix {};
  kiro-account-manager = callPackage ./pkgs/k/kiro-account-manager/package.nix {};
  kiro-cli = callPackage ./pkgs/k/kiro-cli/package.nix {};
  kiro-crew = callPackage ./pkgs/k/kiro-crew/package.nix {};
  craft-agents = callPackage ./pkgs/c/craft-agents/package.nix {};
  codegraph = callPackage ./pkgs/c/codegraph/package.nix {};
  claude-agent-acp = callPackage ./pkgs/c/claude-agent-acp/package.nix {};
  hermes-agent = callPackage ./pkgs/h/hermes-agent/package.nix {
    uv2nix = uv2nix;
    pyproject-nix = pyproject-nix;
    pyproject-build-systems = pyproject-build-systems;
    npm-lockfile-fix = npm-lockfile-fix-pkg;
  };
  struct2json = callPackage ./pkgs/s/struct2json/package.nix {
    pkgs = pkgs;
  };
  smolvm = callPackage ./pkgs/s/smolvm/package.nix {};
  solomd = callPackage ./pkgs/s/solomd/package.nix {};
  tla-toolbox = callPackage ./pkgs/t/tla-toolbox/package.nix {};
  llmfit = callPackage ./pkgs/l/llmfit/package.nix {};
  openwolf = callPackage ./pkgs/o/openwolf/package.nix {};
  my-ttf-fonts = callPackage ./pkgs/f/fonts/package.nix {};
in
{
  xbuild = xbuild;
  capnpc = capnpc;
  cedro  = cedro;
  gost-ctl = gost-ctl;
  zlog_with_pkgconf = zlog_with_pkgconf;
  tinylog = tinylog;
  unity_test_with_color = unity_test_with_color;
  uem = uem;
  deepseek-tui = deepseek-tui;
  kiro-account-manager = kiro-account-manager;
  kiro-cli = kiro-cli;
  kiro-crew = kiro-crew;
  craft-agents = craft-agents;
  codegraph = codegraph;
  claude-agent-acp = claude-agent-acp;
  hermes-agent = hermes-agent;
  libcello_debug = libcello_debug;
  packcc = packcc_main;
  smolvm = smolvm;
  solomd = solomd;
  struct2json = struct2json;
  tla-toolbox = tla-toolbox;
  llmfit = llmfit;
  openwolf = openwolf;
  my-ttf-fonts = my-ttf-fonts;
}
