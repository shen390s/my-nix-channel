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
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "Hmbown";
    repo = "CodeWhale";
    rev = "v0.9.8";
    hash = "sha256-/j43zxaC7rOu4M2Sk9khI/Bb2drs9n/WghhJiKqQDyU=";
  };

  cargoHash = lib.fakeHash;

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus openssl ];

  meta = {
    description = "Agentic terminal facade for open-source and open-weight coding models (formerly DeepSeek-TUI)";
    homepage = "https://github.com/Hmbown/CodeWhale";
    license = lib.licenses.mit;
    mainProgram = "codewhale";
  };
}
