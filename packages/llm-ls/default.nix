{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "llm-ls";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "llm-ls";
    rev = version;
    hash = "sha256-cq91aejGyJv0NnUoeIBm48/hUlI5Of1ZG/tjHWggRsk=";
  };

  cargoHash = "sha256-JGCD8CXxbWwygVfpohM9yyFP/KGN604I4bSayg/gQzM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = with lib; {
    description = "LSP server leveraging LLMs for code completion (and more";
    homepage = "https://github.com/huggingface/llm-ls";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
