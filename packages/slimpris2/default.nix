{
  lib,
  fetchFromGitHub,
  python3,
  wrapGAppsHook,
  gobject-introspection,
  libsoup,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "slimpris2";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "mavit";
    repo = "slimpris2";
    rev = version;
    hash = "sha256-NK8p8DbK/t7DL7rtxeHVy3lk+9U0tZjEVqVDmtcVgXM=";
  };

  patches = [
    ./po-and-sysconf.patch
  ];

  propagatedBuildInputs = with python3.pkgs; [dbus-python pygobject3 pyxdg simplejson six];

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
    libsoup
  ];

  dontWrapGApps = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/dbus-1/services
    install -m 0555 src/slimpris2.py.in $out/bin/slimpris2
    cp src/org.mpris.MediaPlayer2.slimpris2.service.in $out/share/dbus-1/services/org.mpris.MediaPlayer2.slimpris2.service

    substituteInPlace $out/share/dbus-1/services/org.mpris.MediaPlayer2.slimpris2.service --replace '@bindir@' $out/bin

    wrapProgram $out/bin/slimpris2 \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix LD_LIBRARY_PATH ":" "${libsoup.out}/lib" \
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  format = "other";

  meta = {
    description = "MPRIS remote control of Logitech Media Server";
    homepage = "https://github.com/mavit/slimpris2";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [adamcstephens];
  };
}
