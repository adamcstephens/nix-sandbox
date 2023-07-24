{
  lib,
  stdenv,
  fetchFromGitHub,
  avahi,
  cmake,
  libjpeg,
  libpng,
  libusb1,
  sane-backends,
}:
stdenv.mkDerivation rec {
  pname = "airsane";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "SimulPiscator";
    repo = "AirSane";
    rev = "refs/tags/v${version}";
    hash = "sha256-J6u9+3ff24sl0YXiCDyoMtwhBgugWXagS1G4lTnDBN8=";
  };

  patches = [
    ./disable-etc-write.patch
  ];

  nativeBuildInputs = [
    cmake
    libjpeg
    libpng
    libusb1
  ];

  buildInputs = [
    avahi
    sane-backends
  ];

  meta = with lib; {
    homepage = "https://github.com//airsane";
    description = "";
    license = licenses.gpl3;
    maintainers = with maintainers; [adamcstephens];
    platforms = platforms.linux;
  };
}
