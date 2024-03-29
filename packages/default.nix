{ withSystem, ... }:
{
  flake.packages.aarch64-darwin = withSystem "aarch64-darwin" (
    { pkgs, ... }:
    {
      m1ddc = pkgs.darwin.apple_sdk_11_0.callPackage ./m1ddc {
        inherit (pkgs.darwin.apple_sdk_11_0.frameworks) Foundation IOKit;
      };
      mautrix-imessage = pkgs.darwin.apple_sdk_11_0.callPackage ./mautrix-imessage {
        inherit (pkgs.darwin.apple_sdk_11_0.frameworks) Contacts;
      };
      mautrix-wsproxy = pkgs.darwin.apple_sdk_11_0.callPackage ./mautrix-wsproxy { };
    }
  );

  flake.packages.x86_64-linux = withSystem "x86_64-linux" (
    { pkgs, ... }:
    {
      cups-brother-hll2370dw = pkgs.callPackage ./cups-brother-hll2370dw { };
    }
  );

  perSystem =
    { lib, pkgs, ... }:
    {
      packages = rec {
        # pytest-flake8 broken
        # aio-mqtt-mod = pkgs.callPackage ./aio-mqtt-mod {
        #   buildPythonPackage = pkgs.python3Packages.buildPythonPackage;
        #   fetchPypi = pkgs.python3Packages.fetchPypi;
        #   safety = pkgs.python3Packages.safety;
        #   pytest = pkgs.python3Packages.pytest;
        #   pytest-cov = pkgs.python3Packages.pytest-cov;
        #   pytest-flake8 = pkgs.python3Packages.pytest-flake8;
        #   pytest-mypy = pkgs.python3Packages.pytest-mypy;
        # };

        # airsane = pkgs.callPackage ./airsane {};

        consrv = pkgs.callPackage ./consrv { };
        firefox-profile-switcher-connector =
          pkgs.darwin.apple_sdk_11_0.callPackage ./firefox-profile-switcher-connector
            { inherit (pkgs.darwin.apple_sdk_11_0.frameworks) Security; };
        fish = pkgs.callPackage ./fish { };
        fork-cleaner = pkgs.callPackage ./fork-cleaner { };
        gickup = pkgs.callPackage ./gickup { };

        # needs aio-mqtt-mod
        # ble2mqtt = pkgs.callPackage ./ble2mqtt {
        #   buildPythonApplication = pkgs.python3Packages.buildPythonApplication;
        #   aio-mqtt-mod = aio-mqtt-mod;
        #   bleak = pkgs.python3Packages.bleak;
        # };

        iguanair = pkgs.callPackage ./iguanair { };
        lirc-drv-iguanair = pkgs.callPackage ./lirc-drv-iguanair { inherit iguanair; };
        llm-ls = pkgs.callPackage ./llm-ls { };

        # deps still not working
        # json-tui = pkgs.callPackage ./json-tui {
        #   ftxui = pkgs.ftxui.overrideAttrs (_: rec {
        #     version = "4.0.0";
        #     src = pkgs.fetchFromGitHub {
        #       owner = "ArthurSonzogni";
        #       repo = "ftxui";
        #       rev = "v${version}";
        #       sha256 = "sha256-3kAhHDUwzwdvHc8JZAcA14tGqa6w69qrN1JXhSxNBQY=";
        #     };

        #     patches = [];
        #   });
        # };

        maskedemail-cli = pkgs.callPackage ./maskedemail-cli { };
        mdns-reflector = pkgs.callPackage ./mdns-reflector { };
        oidc-filter = pkgs.callPackage ./oidc-filter { };

        # ERROR: No matching distribution found for pick==1.6.0
        # qobuz-dl = pkgs.callPackage ./qobuz-dl {};

        # surface-dial = pkgs.callPackage ./surface-dial {};
        rs-tftpd = pkgs.callPackage ./rs-tftpd { };

        trippy = pkgs.callPackage ./trippy { };
        # upplay = pkgs.callPackage ./upplay {
        #   inherit (pkgs.qt6) qtbase qmake qtwebengine wrapQtAppsHook;

        #   libupnpp = pkgs.callPackage ./libupnpp {
        #     npupnp = pkgs.callPackage ./npupnp {};
        #   };
        # };
        # xautocfg = pkgs.callPackage ./xautocfg {};
        # xmos_dfu = pkgs.callPackage ./xmos_dfu {};
        ydls = pkgs.callPackage ./ydls { };
      };
    };
}
