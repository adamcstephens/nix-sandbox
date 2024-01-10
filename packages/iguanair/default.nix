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
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "iguanaworks";
    repo = "iguanair";
    rev = "c8b21bc652ab104db1269a140a92584a9cef3bc1";
    sha256 = "sha256-AUqbvetzunHsV40w/IeutkXI3tkjezH0oqxylgka9Ww=";
  };

  sourceRoot = "source/software/usb_ir";

  buildInputs = [ libusb1 ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  postConfigure = ''
    substituteInPlace cmake_install.cmake \
      --replace "/var/empty" "/usr"
  '';

  postInstall = ''
    mv $out/lib64 $out/lib
  '';

  patches = [ ./systemd.patch ];
}
