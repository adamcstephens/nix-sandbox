{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  curl,
  expat,
  npupnp,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "libupnpp";
  version = "0.22.4";

  outputs = ["out" "dev"];

  src = fetchgit {
    url = "https://framagit.org/medoc92/libupnpp";
    rev = "libupnpp-v${version}";
    hash = "sha256-Iha8jbTAH0MFP63DUo+HPuvFUgZWyYdZGYbyNsZcJV0=";
  };

  buildInputs = [
    curl
    expat
    npupnp
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = with lib; {
    description = "";
    homepage = "https://framagit.org/medoc92/libupnpp";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [];
  };
}
