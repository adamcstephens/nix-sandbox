{
  fetchFromGitHub,
  stdenv,
  libusb1,
  lirc,
  pkg-config,
  cmake,
  ...
}:
stdenv.mkDerivation {
  pname = "iguanair";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "iguanaworks";
    repo = "iguanair";
    rev = "c6284e5c07993db7adfa2729b7a3503224301572";
    sha256 = "sha256-43OaTMVgoC3bcS7eiuHEvFlO+HlYVxXzhbNujpOqji4=";
  };

  sourceRoot = "source/software/usb_ir";

  buildInputs = [
    libusb1
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  postConfigure = ''
    substituteInPlace cmake_install.cmake \
      --replace "/var/empty" "/usr"
  '';

  patches = [
    ./systemd.patch
  ];
}
