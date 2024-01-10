{
  lib,
  stdenv,
  fetchgit,
  libmicrohttpd,
  cmake,
  curl,
  expat,
  meson,
  ninja,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "npupnp";
  version = "5.0.1";

  src = fetchgit {
    url = "https://framagit.org/medoc92/npupnp";
    rev = "libnpupnp-v${version}";
    hash = "sha256-ajs/bqfgbJdlte5ifxcc2VHpLh+ui36tr38sh+IyCrE=";
  };

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [
    curl
    expat
    libmicrohttpd
  ];

  nativeBuildInputs = [
    cmake
    meson
    ninja
    pkg-config
  ];

  dontUseCmakeConfigure = true;

  meta = with lib; {
    description = "";
    homepage = "https://framagit.org/medoc92/npupnp";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
