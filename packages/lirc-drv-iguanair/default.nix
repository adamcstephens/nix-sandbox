{
  fetchFromGitHub,
  stdenv,
  libusb1,
  lirc,
  pkg-config,
  iguanair,
  ...
}:
stdenv.mkDerivation {
  pname = "lirc-drv-iguanair";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "iguanaworks";
    repo = "iguanair";
    rev = "c8b21bc652ab104db1269a140a92584a9cef3bc1";
    sha256 = "sha256-AUqbvetzunHsV40w/IeutkXI3tkjezH0oqxylgka9Ww=";
  };

  sourceRoot = "source/software/lirc-drv-iguanair";

  buildInputs = [
    lirc
    iguanair
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  makeFlags = [
    "CONFIGDIR=$(out)/share/lirc/configs/"
    "PLUGINDIR=$(out)/lib/lirc/plugins/"
    "PLUGINDOCS=$(out)/share/doc/lirc/plugindocs"
  ];

  patches = [
    ./skip-modprobe-blacklist.patch
  ];
}
