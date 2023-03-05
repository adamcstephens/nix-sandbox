{
  aio-mqtt-mod,
  bleak,
  buildPythonApplication,
  fetchFromGitHub,
  lib,
}:
buildPythonApplication rec {
  pname = "ble2mqtt";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "devbis";
    repo = pname;
    rev = version;
    hash = "sha256-MpLfJObJ3Ikr8DgLoOPcP80o+qI2LCXthKp+FSasIfE=";
  };

  postInstall = ''
    mkdir $out/share
    cp ble2mqtt.json.sample $out/share
  '';

  propagatedBuildInputs = [
    aio-mqtt-mod
    bleak
  ];

  meta = with lib; {
    description = "Bluetooth to MQTT bridge";
    homepage = "https://github.com/devbis/ble2mqtt";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [adamcstephens];
  };
}
