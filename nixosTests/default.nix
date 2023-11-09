{
  self,
  withSystem,
  ...
}: {
  flake.checks.x86_64-linux = withSystem "x86_64-linux" ({pkgs, ...}: {
    ydls = import ./ydls.nix {
      inherit pkgs;
      flake = self;
      makeTest = import (pkgs.path + "/nixos/tests/make-test-python.nix");
    };
  });
}
