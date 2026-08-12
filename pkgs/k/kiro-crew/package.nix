{
  lib,
  python312Packages,
  fetchFromGitHub,
  nodejs_22,
  makeWrapper,
  uv,
}:

let
  python = python312Packages;

  # pdfplumber's test suite pulls in scipy/jupyter-server which have flaky tests.
  # Override pdfplumber to skip its check phase to avoid those transitive test failures.
  pdfplumber = python.pdfplumber.overridePythonAttrs (old: {
    doCheck = false;
    doInstallCheck = false;
  });

  # Pre-built dashboard SPA (built from website/ with `npm ci && npx vite build`).
  # To rebuild: cd into a KiroCrew v0.2.0 checkout, cd website,
  # npm ci --noproxy registry.npmjs.org && npx vite build
  # then replace pkgs/k/kiro-crew/dashboard.tar.gz with website/dist tarball.
  dashboard = builtins.path {
    name = "kirocrew-dashboard-0.2.0";
    path = ./dashboard.tar.gz;
  };
in python.buildPythonApplication rec {
  pname = "kirocrew";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kirodotdev";
    repo = "KiroCrew";
    rev = "v${version}";
    hash = "sha256-TAJ83PKF7BZM7JDsy3aS/ONP6aOvphj80JkoSfoo2cg=";
  };

  build-system = [
    python.setuptools
    python.wheel
  ];

  dependencies = [
    python.aiohttp
    python.yarl
    python.websockets
    python.cron-descriptor
    python.croniter
    python.numpy
    python.snowballstemmer
    python.jinja2
    python.typing-extensions
    python.python-docx
    pdfplumber
    python.defusedxml
    python.qrcode
    python.cryptography
    python.requests
    python.pyyaml
    python.opentelemetry-api
    python.opentelemetry-sdk
    python.slack-sdk
  ];

  nativeBuildInputs = [
    makeWrapper
    python.pythonRelaxDepsHook
  ];

  # Relax version pins that are too strict for nixpkgs-unstable
  pythonRelaxDeps = [
    "websockets"
    "cron-descriptor"
    "croniter"
  ];

  # pysqlite3-binary is a binary wheel not available in nixpkgs;
  # Python 3.12 ships sqlite3 in its stdlib which is sufficient.
  pythonRemoveDeps = [
    "pysqlite3-binary"
    "uv"
  ];

  # Skip tests — they require network and dev tooling
  doCheck = false;

  # Fix: shutil.copytree from Nix store preserves read-only permissions,
  # causing PermissionError when writing the .kirocrew-managed marker.
  patches = [
    ./fix-copytree-perms.patch
  ];

  # Stage the pre-built dashboard into the source tree so setup.py's
  # BuildWithFrontend class picks it up and includes it in the wheel.
  preBuild = ''
    mkdir -p src/kiro_crew/static/dist
    tar xzf ${dashboard} -C src/kiro_crew/static/dist/
  '';

  postInstall = ''
    wrapProgram $out/bin/kirocrew \
      --prefix PATH : ${lib.makeBinPath [ nodejs_22 uv ]}
  '';

  meta = {
    description = "Kiro Crew - persistent AI development workspace that self-improves across sessions";
    homepage = "https://github.com/kirodotdev/KiroCrew";
    license = lib.licenses.asl20;
    mainProgram = "kirocrew";
    platforms = lib.platforms.unix;
  };
}
