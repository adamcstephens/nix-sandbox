{
  lib,
  buildGoModule,
  fetchgit,
}:
buildGoModule rec {
  pname = "ntfy-alertmanager";
  version = "0.2.0";

  src = fetchgit {
    url = "https://git.xenrox.net/~xenrox/ntfy-alertmanager";
    rev = "v${version}";
    hash = "sha256-MiXnatC3wtwVTr4Kl9G+otwLyCnmFU1uR2OvdkEKfHk=";
  };

  vendorHash = "sha256-9fecPIKPC64NpllRPCLyrAYRskUtatxo3j7DbjzNiS0=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "";
    homepage = "https://git.xenrox.net/~xenrox/ntfy-alertmanager";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [adamcstephens];
  };
}
