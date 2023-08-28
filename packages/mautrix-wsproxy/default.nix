{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mautrix-wsproxy";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "wsproxy";
    rev = "v${version}";
    hash = "sha256-IJGCRJENgsESpYfsMhwCLh/KP1EmrrGEkIt2qDUfDyg=";
  };

  vendorHash = "sha256-MMEm5Zbb1wI19WoEcM/7XWcpnvMO24dI69G2Fz/FH0E=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "A simple HTTP push -> websocket proxy for Matrix appservices";
    homepage = "https://github.com/mautrix/wsproxy";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [];
  };
}
