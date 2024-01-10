{
  lib,
  stdenv,
  fetchgit,
  libupnpp,
  qtbase,
  qmake,
  qtwebengine,
  wrapQtAppsHook,
}:
stdenv.mkDerivation rec {
  pname = "upplay";
  version = "1.6.6";

  src = fetchgit {
    url = "https://framagit.org/medoc92/upplay";
    rev = "UPPLAY_${version}";
    hash = "sha256-XMA/Oprr/Jclrc5YBD+5/KQZ84Ql+JKckl8zsWfHMs4=";
  };

  patches = [ ./force-webengine.patch ];

  buildInputs = [
    libupnpp.dev
    qtbase
    qtwebengine
  ];
  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  meta = with lib; {
    description = "";
    homepage = "https://framagit.org/medoc92/upplay";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ adamcstephens ];
  };
}
