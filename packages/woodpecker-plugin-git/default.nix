{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git-lfs,
  git,
  gitFull,
  makeWrapper,
  openssh,
  symlinkJoin,
}:
buildGoModule rec {
  pname = "woodpecker-plugin-git";
  version = "2.1.0-dev";

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "plugin-git";
    rev = "388c4cd007387656ac016e7e8d32f4a92940eb9f";
    hash = "sha256-FmThS1h8gaJ3K4OP/gZ/VYhAOL10eK5XSyVOelvE5Vk=";
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
