{
  perSystem,
  withSystem,
  ...
}: {
  flake.packages.aarch64-darwin = withSystem "aarch64-darwin" ({pkgs, ...}: {
    m1ddc = pkgs.darwin.apple_sdk_11_0.callPackage ./m1ddc {
      inherit (pkgs.darwin.apple_sdk_11_0.frameworks) Foundation IOKit;
    };
  });

  perSystem = {
    lib,
    pkgs,
    ...
  }: {
    packages = rec {
      # aio-mqtt-mod = pkgs.callPackage ./aio-mqtt-mod {
      #   buildPythonPackage = pkgs.python3Packages.buildPythonPackage;
      #   fetchPypi = pkgs.python3Packages.fetchPypi;
      #   safety = pkgs.python3Packages.safety;
      #   pytest = pkgs.python3Packages.pytest;
      #   pytest-cov = pkgs.python3Packages.pytest-cov;
      #   pytest-flake8 = pkgs.python3Packages.pytest-flake8;
      #   pytest-mypy = pkgs.python3Packages.pytest-mypy;
      # };

      airsane = pkgs.callPackage ./airsane {};

      # ble2mqtt = pkgs.callPackage ./ble2mqtt {
      #   buildPythonApplication = pkgs.python3Packages.buildPythonApplication;
      #   aio-mqtt-mod = aio-mqtt-mod;
      #   bleak = pkgs.python3Packages.bleak;
      # };

      iguanair = pkgs.callPackage ./iguanair {};
      lirc-drv-iguanair = pkgs.callPackage ./lirc-drv-iguanair {inherit iguanair;};

      mopidy-qobuz-hires = pkgs.callPackage ./mopidy-qobuz-hires {};

      rush-parallel = pkgs.callPackage ./rush-parallel {};
      surface-dial = pkgs.callPackage ./surface-dial {};

      trippy = pkgs.callPackage ./trippy {};
      xautocfg = pkgs.callPackage ./xautocfg {};
      xmos_dfu = pkgs.callPackage ./xmos_dfu {};
    };
  };
}
