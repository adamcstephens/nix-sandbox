{
  lib,
  stdenv,
  fetchFromGitHub,
  Foundation,
  IOKit,
}:
stdenv.mkDerivation rec {
  pname = "m1ddc";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "waydabber";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-eT4xeO1MgKw6DFe/jGeCtTkEwFmzVC0s54UlSOsvjWU=";
  };

  patchPhase = ''
    runHook prePatch

    # gnumake doesn't support this target
    substituteInPlace Makefile --replace '$' ""

    # patch out constant which requires sdk 12, this should choose the default still
    substituteInPlace m1ddc.m --replace 'kIOMainPortDefault' 'MACH_PORT_NULL'
    runHook postPatch
  '';

  nativeBuildInputs = [
    Foundation
    IOKit
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp m1ddc $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/waydabber/m1ddc";
    description = "Controls external displays (connected via USB-C/DisplayPort Alt Mode) using DDC/CI on M1 Macs";
    license = licenses.mit;
    maintainers = with maintainers; [ adamcstephens ];
    platforms = platforms.darwin;
  };
}
