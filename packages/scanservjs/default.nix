{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  sane-frontends,
}:
buildNpmPackage rec {
  pname = "scanservjs";
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "sbs20";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-vB1CSQHeu7I5XBjN2uSo5/jI9SMiZ2P/Cg92Tux7qG8=";
  };

  npmDepsHash = "sha256-ZK1gbCDv+Dw713kt0dOIeqX7Hm4RfRzzS620u6vfIf0=";

  nativeBuildInputs = [sane-frontends];

  npmPackFlags = ["--ignore-scripts"];

  NODE_OPTIONS = "--openssl-legacy-provider";

  meta = with lib; {
    homepage = "https://github.com/sbs20/scanservjs";
    description = "";
    license = licenses.gpl2;
    maintainers = with maintainers; [adamcstephens];
    platforms = platforms.linux;
  };
}
