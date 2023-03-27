{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.mdns-reflector;

  interfaces = builtins.toString cfg.interfaces;
in {
  options = {
    services.mdns-reflector = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable mdns-reflector.
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.mdns-reflector;
        defaultText = lib.literalExpression "pkgs.mdns-reflector";
        description = "mdns-reflector package to use.";
      };

      interfaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Interfaces to reflect on";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.mdns-reflector = {
      description = "mdns-reflector daemon";
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        User = "mdns-reflector";
        DynamicUser = "yes";
        ExecStart = "${cfg.package}/bin/mdns-reflector -fnl info ${interfaces}";
        RuntimeDirectory = "mdns-reflector";
      };
    };
  };
}
