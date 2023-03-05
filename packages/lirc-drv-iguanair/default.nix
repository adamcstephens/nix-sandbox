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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "iguanaworks";
    repo = "iguanair";
    rev = "c6284e5c07993db7adfa2729b7a3503224301572";
    sha256 = "sha256-43OaTMVgoC3bcS7eiuHEvFlO+HlYVxXzhbNujpOqji4=";
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
