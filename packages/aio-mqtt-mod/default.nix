{
  lib,
  safety,
  pytest,
  pytest-cov,
  pytest-flake8,
  pytest-mypy,
  buildPythonPackage,
  fetchPypi,
}:
buildPythonPackage rec {
  pname = "aio-mqtt-mod";
  version = "0.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-32a8HMzUfhFOfM2KZozbLhTpOXgLmiBWUGfyfYZMNl0=";
  };

  patches = [ ./test-deps.patch ];

  checkInputs = [
    pytest
    pytest-cov
    pytest-flake8
    pytest-mypy
    safety
  ];

  pythonImportsCheck = [ "aio_mqtt" ];

  meta = with lib; {
    description = "MQTT client";
    homepage = "https://github.com/devbis/aio-mqtt";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ adamcstephens ];
  };
}
