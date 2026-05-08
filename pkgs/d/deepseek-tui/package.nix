{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  openssl,
}:

rustPlatform.buildRustPackage {
  pname = "deepseek-tui";
  version = "0.8.20";

  src = fetchFromGitHub {
    owner = "shen390s";
    repo = "DeepSeek-TUI";
    rev = "f183501fbd2199d9d10040e1a63392de604f172c";
    hash = "sha256-E621hEtWjdr5c9MZsifaYgdjyFvXcMvKLFmiyC4+Hr8=";
  };

  cargoHash = "sha256-7Atb+VhGHk1RtNJl+7kJOimpc/4sZs/pTKDRWmUzoSI=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus openssl ];

  meta = {
    description = "A TUI client for DeepSeek AI";
    homepage = "https://github.com/shen390s/DeepSeek-TUI";
    license = lib.licenses.mit;
    mainProgram = "deepseek";
  };
}
