{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  openssl,
}:

rustPlatform.buildRustPackage {
  pname = "codewhale";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "Hmbown";
    repo = "DeepSeek-TUI";
    rev = "v0.9.3";
    hash = "sha256-ORFcZ4+8FEzJPday6wkarnB2QGUiyb302/KGNaB7cVE=";
  };

  cargoHash = "sha256-/Cdix/RctW51NVg5pbmZ7acbB7+3EmI0ByJS77cj88k=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus openssl ];

  meta = {
    description = "Agentic terminal facade for open-source and open-weight coding models (formerly DeepSeek-TUI)";
    homepage = "https://github.com/Hmbown/DeepSeek-TUI";
    license = lib.licenses.mit;
    mainProgram = "codewhale";
  };
}
