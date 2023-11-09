# Debug like this:
# $ nix build .\#checks.x86_64-linux.nixos-test.driver
# $ ./result/bin/nixos-test-driver --interactive
# >>> start_all()
# >>> machine.shell_interact()
{
  flake,
  makeTest,
  pkgs,
}:
makeTest {
  name = "ydls";

  nodes.machine = {...}: {
    imports = [
      flake.nixosModules.ydls
    ];

    services.ydls = {
      enable = true;
      package = flake.packages.${pkgs.system}.ydls;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("ydls.service")
  '';
} {
  inherit pkgs;
  inherit (pkgs) system;
}
