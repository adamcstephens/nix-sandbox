{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mautrix-imessage";
  version = "unstable-2023-08-14";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "imessage";
    rev = "bc457ec994616f5c38f6f82568ff8a84f9c84cb3";
    hash = "sha256-UTeeaGBjLQC8wcQ+xb7ZhBS+5nfmErY9JNcTmjoVrB4=";
  };

  vendorHash = "sha256-TOKQZ4daEwXp5olLXHyOxoFItT26Xaa38P9t6c99M8I=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A Matrix-iMessage puppeting bridge";
    homepage = "https://github.com/mautrix/imessage";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ];
  };
}
