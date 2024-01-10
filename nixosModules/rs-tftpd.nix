{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.rs-tftpd;
in
{
  options.services.rs-tftpd = {
    enable = lib.mkEnableOption (lib.mdDoc "rs-tftpd");

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.rs-tftpd;
    };

    ipAddress = lib.mkOption {
      type = lib.types.str;
      description = "Set the ip address of the server";
      default = "127.0.0.1";
    };

    directory = lib.mkOption {
      type = lib.types.str;
      description = "Set the serving directory";
      default = "/var/lib/rs-tftpd";
    };

    readOnly = lib.mkEnableOption (lib.mdDoc "Refuse all write requests, making the server read-only");
    singlePort = lib.mkEnableOption (lib.mdDoc "Use a single port for both sending and receiving");
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.rs-tftpd = {
      after = [ "network.target" ];
      description = "rs-tftpd daemon";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "rs-tftpd";
        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package} --ip-address ${cfg.ipAddress} --directory ${cfg.directory} ${lib.optionalString cfg.readOnly "--read-only"} ${lib.optionalString cfg.singlePort "--single-port"}";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      };
    };
  };
}
