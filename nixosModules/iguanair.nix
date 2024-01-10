{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.igdaemon;
in
{
  options = {
    services.igdaemon = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable igdaemon.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.iguanair;
        defaultText = literalExpression "pkgs.iguanair";
        description = "iguanair package to use.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.igdaemon = {
      description = "iguanair daemon";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "iguanair";
        ExecStart = "${cfg.package}/bin/igdaemon --driver=libusb --log-level=1 --send-timeout=1000 --receive-timeout=1000 --no-daemon ";
        RuntimeDirectory = "iguanaIR";
      };
    };

    users = {
      users.iguanair = {
        description = "iguanair daemon user";
        group = "iguanair";
        isSystemUser = true;
      };
      groups.iguanair = { };
    };

    services.udev.extraRules = ''
      ATTR{idVendor}=="1781", ATTRS{idProduct}=="0938", MODE="660", GROUP="iguanair"
    '';
  };
}
