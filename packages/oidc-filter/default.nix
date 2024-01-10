{
  lib,
  rustPlatform,
  cargo,
  fetchFromGitHub,
  rustc-wasm32,
  symlinkJoin,
  wasm-pack,
}:
rustPlatform.buildRustPackage rec {
  pname = "oidc-filter";
  version = "unstable-2022-10-25";

  src = fetchFromGitHub {
    owner = "dgn";
    repo = "oidc-filter";
    rev = "a89ae5aa395cdc071f1d8f9443e1eb0deb3945c8";
    hash = "sha256-qS+2xkUiuCmLzCoWGKR44keIyhi8yLLcQTkfiwwSpxg=";
  };

  cargoHash = "sha256-JLQcDiInD5ouSGIAMzzSNOx2N6GoYMaOfcW/EXS3p0I=";

  # RUSTFLAGS = "-C linker=lld";
  # CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER = "lld";

  preBuild = ''
    set -x
  '';

  # cargoBuildFlags = ["--target" "wasm32-unknown-unknown"];
  CARGO_BUILD_TARGET = "wasm32-unknown-unknown";

  # buildPhase = ''
  #   cargo build --target wasm32-unknown-unknown --release
  # '';

  buildInputs = [
    (symlinkJoin {
      name = "rust-lld";
      paths = [rustc-wasm32.llvmPackages.lld];
      postBuild = ''
        ln -s $out/bin/lld $out/bin/rust-lld
      '';
    })
    # rustPlatform.bindgenHook
    cargo
    rustc-wasm32
    rustc-wasm32.llvmPackages.lld
    # wasm-bindgen-84
    # wasm-pack
  ];

  doCheck = false;

  meta = with lib; {
    description = "A WASM plugin for Envoy supporting the Open ID Connect Authorization Flow, extending Istio's JWT functionality";
    homepage = "https://github.com/dgn/oidc-filter/tree/master";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "oidc-filter";
  };
}
