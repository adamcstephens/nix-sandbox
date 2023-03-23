{stdenv}:
stdenv.mkDerivation {
  name = "firstdep";

  src = ./.;

  buildPhase = ''
    runHook preBuild
    echo ":: Building firstdep"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    touch $out/firstdep
    echo ":: Installing firstdep"
    runHook postInstall
  '';

  # dontConfigure = true;
  # dontPatch = true;
  # dontFixup = true;

  setupHook = ./setup-hook.sh;
}
