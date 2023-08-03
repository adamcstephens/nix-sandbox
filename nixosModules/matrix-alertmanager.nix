{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.prometheus.alertmanager.matrix;
in {
  options.services.prometheus.alertmanager.matrix = {
    enable = lib.mkEnableOption "Enable and run the matrix-alertmanager service";

    package = lib.mkPackageOptionMD pkgs "matrix-alertmanager" {
      default = pkgs.matrix-alertmanager;
    };

    environment = lib.mkOption {
      description = lib.mdDoc "Environment variables to be passed as configuration. See [example env file](https://github.com/jaywink/matrix-alertmanager/blob/master/.env.default)";
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = {MATRIX_USER = "@alertmanager:homeserver.tld";};
    };

    environmentFile = lib.mkOption {
      description = lib.mdDoc "Environment file to be passed to the systemd service. Useful for passing secrets to the service to prevent them from being world-readable in the Nix store. Note however that the secrets are passed to `wstunnel` through the command line, which makes them locally readable for all users of the system at runtime.";
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/var/lib/secrets/matrix-alertmanager";
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.matrix-alertmanager = {
      description = "Alertmanager webhook events to Matrix";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      environment =
        {
          NODE_CONFIG_DIR = "/var/lib/matrix-alertmanager/config";
          NODE_ENV = "production";
          NPM_CONFIG_CACHE = "/var/cache/matrix-alertmanager/.npm";
        }
        // cfg.environment;
      path = [pkgs.bash pkgs.nodejs];
      script = ''
        npm start
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 20;
        TimeoutSec = 60;
        WorkingDirectory = "${cfg.package}/lib/node_modules/matrix-alertmanager";
        DynamicUser = true;
        StateDirectory = "matrix-alertmanager";
        CacheDirectory = "matrix-alertmanager";
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
      };
    };
  };
}
