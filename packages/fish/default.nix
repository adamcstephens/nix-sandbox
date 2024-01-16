{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  cargo,
  cmake,
  corrosion,
  gettext,
  libclang,
  ncurses,
  pcre2,
  pkg-config,
  rustc,
  sphinx,
}:

stdenv.mkDerivation rec {
  pname = "fish-shell";
  version = "unstable-2024-01-15";

  src = fetchFromGitHub {
    owner = "fish-shell";
    repo = "fish-shell";
    rev = "fdc45452b6ba04a9d8d0e478b3e2048aeacabd97";
    hash = "sha256-bidZWaNRs6F/oA2syKmKWh4/4xmdx51W0Y8lo0wbz98=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "fast-float-0.2.0" = "sha256-tON97uD+zYDWa/XeWWSpUr5WtUalAcswhTRpEpn4VmM=";
      "hexponent-0.3.1" = "sha256-ryezk0RkcsJV6ZiZXd/wo4BdXz3p1IxksirpABOowXs=";
      "pcre2-0.2.3" = "sha256-CdDHtRcuotpzSazCC+gX7/UcGCA2egCW4r5pNOFovgI=";
      "printf-compat-0.1.1" = "sha256-NZP/A5+W7lU00FSS65/hmmJhZ1x/iR3Ch/aWLDVXvo4=";
    };
  };

  postUnpack = ''
    ln -s ${corrosion.src} ./source/corrosion-vendor
  '';

  nativeBuildInputs = [
    cargo
    cmake
    gettext
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    # docs failing on HOME issues: sphinx
  ];

  buildInputs = [
    libclang
    ncurses
    pcre2
  ];

  meta = with lib; {
    description = "The user-friendly command line shell";
    homepage = "https://github.com/fish-shell/fish-shell";
    changelog = "https://github.com/fish-shell/fish-shell/blob/${src.rev}/CHANGELOG.rst";
    license = with licenses; [
      gpl2Only
      mit
      psfl
    ];
    maintainers = with maintainers; [ adamcstephens ];
    mainProgram = "fish";
  };
}
