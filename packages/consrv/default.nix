{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "consrv";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "consrv";
    rev = "v${version}";
    hash = "sha256-8fEPCY86vGWs85r/SaFGkT221SkXmYOAOjJz7lwNF5M=";
  };

  vendorHash = "sha256-vpuepOxAwoB6XXtZQ9FwxkGwr/TBtU7KOe+BZ3Gua5w=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Command consrv is a SSH to serial console bridge server, originally designed for deployment on gokrazy.org devices. Apache 2.0 Licensed";
    homepage = "https://github.com/mdlayher/consrv";
    changelog = "https://github.com/mdlayher/consrv/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
