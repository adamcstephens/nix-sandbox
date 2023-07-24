# https://github.com/NixOS/nixpkgs/pull/167388
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.logiops;
  formats = import ./format.nix {inherit lib pkgs;};
  renderedConfig = (formats.libconfig {}).generate "logid.cfg" cfg.settings;
in {
  options.services.logiops = {
    enable = lib.mkEnableOption (lib.mdDoc "Logiops HID++ configuration");

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.logiops;
      defaultText = lib.literalMD "`pkgs.logiops`";
      description = lib.mdDoc "The package to use for logiops";
    };

    settings = lib.mkOption {
      inherit (formats.libconfig {}) type;
      default = {};
      example = {
        devices = [
          {
            name = "Wireless Mouse MX Master 3";

            smartshift = {
              on = true;
              threshold = 20;
            };

            hiresscroll = {
              hires = true;
              invert = false;
              target = false;
            };

            dpi = 1500;

            buttons = [
              {
                cid = "0x53";
                action = {
                  type = "Keypress";
                  keys = ["KEY_FORWARD"];
                };
              }
              {
                cid = "0x56";
                action = {
                  type = "Keypress";
                  keys = ["KEY_BACK"];
                };
              }
            ];
          }
        ];
      };
      description = ''
        Logid configuration. Refer to
        [the `logiops` wiki](https://github.com/PixlOne/logiops/wiki/Configuration)
        for details on supported values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [pkgs.logitech-udev-rules];
    environment.etc."logid.cfg".source = renderedConfig;

    systemd.packages = [cfg.package];
    systemd.services.logid = {
      wantedBy = ["multi-user.target"];
      restartTriggers = [renderedConfig];
    };
  };

  meta.maintainers = with lib.maintainers; [ckie];
}
