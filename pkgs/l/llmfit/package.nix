{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage {
  pname = "llmfit";
  version = "1.1.10";

  src = fetchFromGitHub {
    owner = "AlexsJones";
    repo = "llmfit";
    rev = "v1.1.10";
    hash = "sha256-i7eYn7g664dDtaBAeh9Y8yIDLy6tWPKXIWDrD4Drajg=";
  };

  cargoHash = "sha256-1lK/zNcSei/DRInfl2I3EanmuXk0LqRVyFF7G3bJPXU=";

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
