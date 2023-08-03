{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "matrix-alertmanager";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "jaywink";
    repo = "matrix-alertmanager";
    rev = "v${version}";
    hash = "sha256-7rsY/nUiuSVkM8fbPPa9DB3c+Uhs+Si/j1Jzls6d2qc=";
  };

  npmDepsHash = "sha256-OI/zlz03YQwUnpOiHAVQfk8PWKsurldpp0PbF1K9zbM=";

  dontNpmBuild = true;

  meta = {
    description = "A bot to receive Alertmanager webhook events and forward them to chosen rooms";
    homepage = "https://github.com/jaywink/matrix-alertmanager";
    changelog = "https://github.com/jaywink/matrix-alertmanager/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [adamcstephens];
  };
}
