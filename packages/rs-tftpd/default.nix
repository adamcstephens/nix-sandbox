{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "rs-tftpd";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "altugbakan";
    repo = "rs-tftpd";
    rev = version;
    hash = "sha256-h8qDCbdL2nF3+faB6VPsr05j0K34hGsFSrhwfmay8MA=";
  };

  cargoHash = "sha256-blpX5/F8gTZaBzRor5BLcDXKTpNmPMc3vyglcB2iRZY=";

  meta = {
    description = "TFTP Server Daemon implemented in Rust";
    homepage = "https://github.com/altugbakan/rs-tftpd";
    license = lib.licenses.mit;
    mainProgram = "tftpd";
    maintainers = with lib.maintainers; [adamcstephens];
  };
}
