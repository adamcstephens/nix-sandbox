{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "gickup";
  version = "0.10.18";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    rev = "refs/tags/v${version}";
    hash = "sha256-9qaGPmrBA/VdXF9D4eSfjZ3xYBSbPKpwG9t2q37sq3I=";
  };

  vendorHash = "sha256-uDZCeIdyx60XJ3Cu2M4HocfDysOu5Edp81/eUf45NcE=";

  ldflags = ["-X main.version=${version}"];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Tool to backup repositories";
    homepage = "https://github.com/cooperspencer/gickup";
    changelog = "https://github.com/cooperspencer/gickup/releases/tag/v${version}";
    maintainers = with lib.maintainers; [adamcstephens rhousand];
    license = lib.licenses.asl20;
  };
}
