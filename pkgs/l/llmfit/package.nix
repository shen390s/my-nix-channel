{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage {
  pname = "llmfit";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "AlexsJones";
    repo = "llmfit";
    rev = "v1.1.6";
    hash = "sha256-960EP+2kuC1lV3VCjNVsIU5DC3FHT87cOc8SC+dQWE4=";
  };

  cargoHash = "sha256-WXPAnFBlP2kAPtVdzbBToNOBYqN62Lf4eKJVd3Wbx+Q=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  doCheck = false;

  meta = {
    description = "Right-size LLM models to your system hardware. Interactive TUI and CLI.";
    homepage = "https://github.com/AlexsJones/llmfit";
    license = lib.licenses.mit;
    mainProgram = "llmfit";
  };
}
