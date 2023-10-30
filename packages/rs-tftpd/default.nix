{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "rs-tftpd";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "altugbakan";
    repo = "rs-tftpd";
    rev = version;
    hash = "sha256-qybwLGbLRnwmUtOzszEW+q5Mwo9/kWP9cYVn9MLNtcs=";
  };

  cargoHash = "sha256-3b/poJDA6jFk9ESk4Qd4DWNoMSyDE71cbaeVVWGhI+w=";

  meta = {
    description = "TFTP Server Daemon implemented in Rust";
    homepage = "https://github.com/altugbakan/rs-tftpd";
    license = lib.licenses.mit;
    mainProgram = "tftpd";
    maintainers = with lib.maintainers; [adamcstephens];
  };
}
