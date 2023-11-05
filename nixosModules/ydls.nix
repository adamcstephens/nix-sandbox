{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.ydls;
in {
  options.services.ydls = {
    enable = lib.mkEnableOption "ydls service";

    package = lib.mkPackageOptionMD pkgs "ydls" {};

    listenAddress = lib.mkOption {
      type = lib.types.str;
      description = "address:port to listen on";
      default = ":8080";
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      description = "path to config file";
      default = "${cfg.package}/share/ydls/ydls.json";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.ydls = {
      wantedBy = ["multi-user.target"];
      after = ["network-online.target"];

      serviceConfig = {
        DyanmicUser = true;
        ExecStart = "${lib.getExe cfg.package} -server -listen ${cfg.listenAddress} -config ${cfg.configFile}";
      };
    };
  };
}
