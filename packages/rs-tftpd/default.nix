{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "rs-tftpd";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "altugbakan";
    repo = "rs-tftpd";
    rev = version;
    hash = "sha256-FYgsDVTppjiIyB7oPeP7KbF5vLJZLj6NQIO+v33ICJw=";
  };

  cargoHash = "sha256-AuClyS3j7I/YLmq8Kwtx15gatNSkWaas46+q3HOBV/M=";

  meta = {
    description = "TFTP Server Daemon implemented in Rust";
    homepage = "https://github.com/altugbakan/rs-tftpd";
    license = lib.licenses.mit;
    mainProgram = "tftpd";
    maintainers = with lib.maintainers; [adamcstephens];
  };
}
