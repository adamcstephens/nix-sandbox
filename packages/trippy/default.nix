{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "trippy";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "fujiapple852";
    repo = "trippy";
    rev = version;
    hash = "sha256-zV8utf/2BRXrPGxE/A5ipcTjJYmn2/Gwp3o15xcIGtM=";
  };

  cargoHash = "sha256-QRFXjnZTDI7jwJHdy/d9CYEuWB26iCp5cqlh/25nckI=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
  ];

  meta = with lib; {
    description = "A network diagnostic tool";
    homepage = "https://github.com/fujiapple852/trippy";
    changelog = "https://github.com/fujiapple852/trippy/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [adamcstephens];
    mainProgram = "trip";
  };
}
