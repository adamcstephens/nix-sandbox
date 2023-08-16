{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gickup";
  # version = "0.10.17";
  version = "unstable-2023-08-16";

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    rev = "f8ad43bb29898ab8b8950a34dd5c48e45887a2cd";
    hash = "sha256-En9MmpbQWQVy7brrWAU2t3K+N6+hDDkgcojj8qoWUkk=";
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
