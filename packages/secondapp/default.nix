{
  stdenv,
  firstdep,
  gnugrep,
}:
stdenv.mkDerivation {
  name = "secondapp";

  src = ./.;

  buildInputs = [
    firstdep
    gnugrep
  ];

  configurePhase = ''
    runHook preConfigure
    echo ":: Using env $MYSETUPHOOK"
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    echo ":: Building secondapp"
    echo ":: Using env $MYSETUPHOOK"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    touch $out
    echo ":: Installing secondapp"
    runHook postInstall
  '';

  # dontConfigure = true;
  # dontPatch = true;
  # dontFixup = true;
  # dontUnpack = true;
}
