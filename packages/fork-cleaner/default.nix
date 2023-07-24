{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fork-cleaner";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "fork-cleaner";
    rev = "v${version}";
    hash = "sha256-pMzX5AaGfsJIZf1R+PAKrDQyx3i9ebd03dY6hBtGGRk=";
  };

  vendorHash = "sha256-yzS6SME2P9Guq4hQcY7Gyd9hrwi2ugIXDev69djdxU0=";

  ldflags = [ "-s" "-w" "-X" "main.version=${version}" "-X" "main.commit=${src.rev}" "-X" "main.date=1970-01-01T00:00:00Z" "-X" "main.builtBy=goreleaser" ];

  meta = with lib; {
    description = "Quickly clean up unused forks on your github account";
    homepage = "https://github.com/caarlos0/fork-cleaner";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
