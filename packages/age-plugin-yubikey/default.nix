{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  pcsclite,
  PCSC,
  Foundation,
}:
rustPlatform.buildRustPackage rec {
  pname = "age-plugin-yubikey";
  version = "0.3.3-dev";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = pname;
    rev = "22fd00bd22ee8a8fe9f3b33db2e4b7eea944bf37";
    sha256 = "sha256-3mvmzGvcXshiROYyU4SSHGCV8KPX2vT34JZmz5KUR3E=";
  };

  cargoSha256 = "sha256-XNLj24DuyIHK15P2QIjcWW1ga3LLF4ZOKP6RiPEoazE=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [pkg-config];

  buildInputs =
    if stdenv.isDarwin
    then [
      Foundation
      PCSC
    ]
    else [
      openssl
      pcsclite
    ];

  meta = with lib; {
    description = "YubiKey plugin for age clients";
    homepage = "https://github.com/str4d/age-plugin-yubikey";
    license = with licenses; [asl20 mit];
    maintainers = with maintainers; [vtuan10];
  };
}
