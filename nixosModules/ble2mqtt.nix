{
  config,
  lib,
  pkgs,
  self',
  ...
}: let
  cfg = config.services.ble2mqtt;

  configFile = pkgs.writeText "ble2mqtt-config.json" (builtins.toJSON config.services.ble2mqtt.config);
in {
  options.services.ble2mqtt = {
    enable = lib.mkEnableOption (lib.mdDoc "ble2mqtt");

    config = lib.mkOption {
      type = lib.types.attrs;
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = self'.packages.ble2mqtt;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    systemd.services.ble2mqtt = {
      after = ["network.target"];
      description = "ble2mqtt daemon";
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        User = "ble2mqtt";
        DynamicUser = true;
        Environment = [
          "BLE2MQTT_CONFIG=${configFile}"
        ];
        ExecStart = "${cfg.package}/bin/ble2mqtt";
      };
    };
  };
}
