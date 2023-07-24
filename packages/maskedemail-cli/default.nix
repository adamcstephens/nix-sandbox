{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "maskedemail-cli";
  version = "unstable-2023-02-18";

  src = fetchFromGitHub {
    owner = "dvcrn";
    repo = "maskedemail-cli";
    rev = "5c272c204a495150fc1b92253446de9021f413f1";
    hash = "sha256-KaFzgCR1PJixtFNqdlNIGdg1YOjbDeTBkmNeMkA7KF4=";
  };

  vendorHash = "sha256-q6DbxF9C0gq9wTDyrZxuED3o4KG1nR9McEavRhEtwYs=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "CLI to create fastmail masked emails";
    homepage = "https://github.com/dvcrn/maskedemail-cli";
    license = with licenses; [ ];
    maintainers = with maintainers; [ ];
  };
}
