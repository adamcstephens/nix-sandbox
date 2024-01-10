{
  lib,
  python3Packages,
  mopidy,
}:
python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Qobuz-Hires";
  version = "0.1.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-B3jQEImfZn5vi2EWdcHp1DDD+CwiQ6xWw3DQSCxUrPg=";
  };

  propagatedBuildInputs = [ mopidy ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/vitiko98/mopidy-qobuz";
    description = "Mopidy extension for controlling playback from MPD clients";
    license = lib.licenses.asl20;
    maintainers = [ maintainers.adamcstephens ];
  };
}
