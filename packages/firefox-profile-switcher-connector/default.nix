{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  Security,
  cmake,
}:
rustPlatform.buildRustPackage rec {
  pname = "firefox-profile-switcher-connector";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "null-dev";
    repo = "firefox-profile-switcher-connector";
    rev = "v${version}";
    hash = "sha256-mnPpIJ+EQAjfjhrSSNTrvCqGbW0VMy8GHbLj39rR8r4=";
  };

  cargoHash = "sha256-EQIBeZwF9peiwpgZNfMmjvLv8NyhvVGUjVXgkf12Wig=";

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = {
    description = "Native connector software for the 'Profile Switcher for Firefox' extension";
    homepage = "https://github.com/null-dev/firefox-profile-switcher-connector";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ adamcstephens ];
  };
}
