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
  version = "0.8.65";

  src = fetchFromGitHub {
    owner = "Hmbown";
    repo = "DeepSeek-TUI";
    rev = "v0.8.65";
    hash = "sha256-OLwQuMV9BX9GDTGPT8S3KoHAhfURPxXgk6OxvMGK5w0=";
  };

  cargoHash = "sha256-Fv1NHzHhc2zQZzdLz0yyZmVkaN7jglSAEtN/XjaVJeY=";

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
