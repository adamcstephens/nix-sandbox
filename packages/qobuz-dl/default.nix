{ lib, python3Packages }:
python3Packages.buildPythonApplication rec {
  pname = "qobuz-dl";
  version = "0.9.9.9";

  src = python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-oGreHuia5lvGOFBR2MoeQjUpRh7Nq95xhY5MJ5QGE7E=";
  };

  buildInputs = [
    python3Packages.pathvalidate
    python3Packages.tqdm
    python3Packages.pick
  ];

  doCheck = false;
  # pythonImportsCheck = ["qobuz_dl"];

  meta = with lib; {
    homepage = "https://github.com/vitiko98/qobuz-dl";
    description = "Search, explore and download Lossless and Hi-Res music from Qobuz";
    license = lib.licenses.gpl3;
    maintainers = [ maintainers.adamcstephens ];
  };
}
