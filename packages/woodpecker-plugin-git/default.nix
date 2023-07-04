{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git-lfs,
  git,
  makeWrapper,
  openssh,
}:
buildGoModule rec {
  pname = "woodpecker-plugin-git";
  version = "2.1.0-dev";

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "plugin-git";
    rev = "31b0c3d3edafe7283b6482e9dc38686e0e9843d1";
    hash = "sha256-aojctYpHCgfG+32Qh8rRGiOSLz9BR8imQqA8FmzvUzc=";
  };

  vendorHash = "sha256-63Ly/9yIJu2K/DwOfGs9pYU3fokbs2senZkl3MJ1UIY=";

  CGO_ENABLED = "0";

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/plugin-git --prefix PATH : ${lib.makeBinPath [git git-lfs openssh]} --run 'echo $PATH'
  '';

  # Checks fail because they require network access.
  doCheck = false;

  ldflags = ["-s" "-w"];

  meta = {
    description = "Woodpecker plugin for cloning Git repositories";
    homepage = "https://github.com/woodpecker-ci/plugin-git";
    changelog = "https://github.com/woodpecker-ci/plugin-git/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [adamcstephens];
    mainProgram = "plugin-git";
  };
}
