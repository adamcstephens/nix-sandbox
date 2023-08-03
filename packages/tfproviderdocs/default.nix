{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tfproviderdocs";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "bflad";
    repo = "tfproviderdocs";
    rev = "v${version}";
    hash = "sha256-lhXh16rpM0sHwX9RTB/AyGC/ytN+O7TINDJLsna2Pwg=";
  };

  vendorHash = "sha256-Rs14FbgqZsUPivPoUrzWgBIrSNzgKx3c9dToHH8Ouko=";

  ldflags = [ "-s" "-w" "-X" "github.com/bflad/tfproviderdocs/version.Version=${version}" "-X" "github.com/bflad/tfproviderdocs/version.VersionPrerelease=" ];

  meta = with lib; {
    description = "Terraform Provider Documentation Tool";
    homepage = "https://github.com/bflad/tfproviderdocs";
    changelog = "https://github.com/bflad/tfproviderdocs/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}
