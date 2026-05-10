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
  version = "0.8.25";

  src = fetchFromGitHub {
    owner = "Hmbown";
    repo = "DeepSeek-TUI";
    rev = "v0.8.25";
    hash = "sha256-ttzRBo7RtIRCogcPkM7z7EkZtWDLvkHCeQFbAPeb0ns=";
  };

  cargoHash = "sha256-1UDsrrh4/OJyr4KOMO4WdetfCzaHE5oFl1yBuoUKDTM=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus openssl ];

  meta = {
    description = "A TUI client for DeepSeek AI";
    homepage = "https://github.com/Hmbown/DeepSeek-TUI";
    license = lib.licenses.mit;
    mainProgram = "deepseek";
  };
}
