{
  lib,
  fetchFromGitHub,
  rustPlatform,
  dbus,
  hidapi,
  libevdev,
  pkg-config,
  udev,
}:
rustPlatform.buildRustPackage {
  name = "surface-dial";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "daniel5151";
    repo = "surface-dial-linux";
    rev = "43dd973092871d8ef0c452b0797b519f5a9ddfac";
    hash = "sha256-8uTiUIDmFU0+JIljfDUDfwkoH/vhMveXBIMmDYMYxPA=";
  };

  cargoHash = "sha256-DuawE3uMvC1ez27Rp/VKvNTIiUdMBbhn53ccCbxeLzc=";

  strictDeps = true;

  buildInputs = [
    dbus
    hidapi
    libevdev
    udev
  ];
  nativeBuildInputs = [
    pkg-config
  ];
}
