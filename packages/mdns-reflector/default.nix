{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "mdns-reflector";
  version = "unstable-2023-03-16";

  src = fetchFromGitHub {
    owner = "vfreex";
    repo = "mdns-reflector";
    rev = "f1bd0f1627a2f518d6f4e4002ebedac1892f17d1";
    hash = "sha256-23ZhHvDM3iCFHqSXTgytLtxbGR8td6i9unSO11PXB6o=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A lightweight and performant multicast DNS (mDNS) reflector with modern design, supports zone based reflection and IPv6";
    homepage = "https://github.com/vfreex/mdns-reflector";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
