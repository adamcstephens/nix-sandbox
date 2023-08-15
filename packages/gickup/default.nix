{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gickup";
  # version = "0.10.17";
  version = "unstable-2023-08-15";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    rev = "f468f48ba113a78503ef4f186834dbcaa9cc8962";
    hash = "sha256-jsg87bAoLEFYZ6vmDz0CvdeF3pW6qf1lw5hPxPNLgZE=";
  };

  vendorHash = "sha256-uDZCeIdyx60XJ3Cu2M4HocfDysOu5Edp81/eUf45NcE=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/cooperspencer/gickup";
    license = licenses.asl20;
    maintainers = with maintainers; [adamcstephens];
  };
}
