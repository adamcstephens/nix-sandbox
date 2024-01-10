{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    any
    attrValues
    concatStringsSep
    escapeShellArg
    hasSuffix
    optionalAttrs
    literalExpression
    mapAttrs'
    mkEnableOption
    mkOption
    mkPackageOption
    mkIf
    nameValuePair
    types
    ;

  cfg = config.services.forgejo-actions-runner;
  user = config.users.users.forgejo-runner;

  settingsFormat = pkgs.formats.yaml { };

  hasHostScheme = instance: any (label: hasSuffix ":host" label) instance.labels;

  tokenXorTokenFile =
    instance:
    (instance.token == null && instance.tokenFile != null)
    || (instance.token != null && instance.tokenFile == null);
in
{
  meta.maintainers = with lib.maintainers; [ adamcstephens ];

  options.services.forgejo-actions-runner = with types; {
    package = mkPackageOption pkgs "forgejo-actions-runner" { };

    instances = mkOption {
      default = { };
      description = lib.mdDoc ''
        Forgejo Actions Runner instances.
      '';
      type = attrsOf (
        submodule {
          options = {
            enable = mkEnableOption (lib.mdDoc "Forgejo Actions Runner instance");

            name = mkOption {
              type = str;
              example = literalExpression "config.networking.hostName";
              description = lib.mdDoc ''
                The name identifying the runner instance towards the Forgejo instance.
              '';
            };

            url = mkOption {
              type = str;
              example = "https://forge.example.com";
              description = lib.mdDoc ''
                Base URL of your Forgejo instance.
              '';
            };

            token = mkOption {
              type = nullOr str;
              default = null;
              description = lib.mdDoc ''
                Plain token to register at the configured Forgejo instance.
              '';
            };

            tokenFile = mkOption {
              type = nullOr (either str path);
              default = null;
              description = lib.mdDoc ''
                Path to an environment file, containing the `TOKEN` environment
                variable, that holds a token to register at the configured
                Forgejo instance.
              '';
            };

            labels = mkOption {
              type = listOf str;
              example = literalExpression ''
                [
                  # provide native execution on the host
                  #"native:host"
                ]
              '';
              description = lib.mdDoc ''
                Labels used to map jobs to their runtime environment. Changing these
                labels currently requires a new registration token.

                Many common actions require bash, git and nodejs, as well as a filesystem
                that follows the filesystem hierarchy standard.
              '';
            };
            settings = mkOption {
              description = lib.mdDoc ''
                Configuration for `act_runner daemon`.
                See https://forgejo.com/forgejo/act_runner/src/branch/main/internal/pkg/config/config.example.yaml for an example configuration
              '';

              type = types.submodule { freeformType = settingsFormat.type; };

              default = { };
            };

            hostPackages = mkOption {
              type = listOf package;
              default = with pkgs; [
                bash
                coreutils
                curl
                gawk
                gitMinimal
                gnused
                nodejs
                wget
              ];
              defaultText = literalExpression ''
                with pkgs; [
                  bash
                  coreutils
                  curl
                  gawk
                  gitMinimal
                  gnused
                  nodejs
                  wget
                ]
              '';
              description = lib.mdDoc ''
                List of packages, that are available to actions, when the runner is configured
                with a host execution label.
              '';
            };
          };
        }
      );
    };
  };

  config = mkIf (cfg.instances != { }) {
    assertions = [
      {
        assertion = any tokenXorTokenFile (attrValues cfg.instances);
        message = "Instances of forgejo-actions-runner can have `token` or `tokenFile`, not both.";
      }
    ];

    launchd.daemons =
      let
        mkRunnerService =
          name: instance:
          let
            wantsHost = hasHostScheme instance;
            configFile = settingsFormat.generate "config.yaml" instance.settings;
          in
          nameValuePair "forgejo-runner-${name}" {
            environment = {
              NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
            } // (optionalAttrs (instance.token != null) { TOKEN = "${instance.token}"; });
            path = with pkgs; [ coreutils ] ++ lib.optionals wantsHost instance.hostPackages;
            script = ''
              set -x
              export INSTANCE_DIR="/var/lib/forgejo-runner/${name}"
              mkdir -vp "$INSTANCE_DIR"
              cd "$INSTANCE_DIR"

              ${lib.optionalString (instance.tokenFile != null) ''
                source ${instance.tokenFile}
                export TOKEN
              ''}

              # force reregistration on changed labels
              export LABELS_FILE="$INSTANCE_DIR/.labels"
              export LABELS_WANTED="$(echo ${escapeShellArg (concatStringsSep "\n" instance.labels)} | sort)"
              export LABELS_CURRENT="$(cat $LABELS_FILE 2>/dev/null || echo 0)"

              if [ ! -e "$INSTANCE_DIR/.runner" ] || [ "$LABELS_WANTED" != "$LABELS_CURRENT" ]; then
                # remove existing registration file, so that changing the labels forces a re-registration
                rm -v "$INSTANCE_DIR/.runner" || true

                # perform the registration
                ${cfg.package}/bin/act_runner register --no-interactive \
                  --instance ${escapeShellArg instance.url} \
                  --token "$TOKEN" \
                  --name ${escapeShellArg instance.name} \
                  --labels ${escapeShellArg (concatStringsSep "," instance.labels)}

                # and write back the configured labels
                echo "$LABELS_WANTED" > "$LABELS_FILE"
              fi

              exec ${cfg.package}/bin/act_runner daemon --config ${configFile}
            '';

            serviceConfig = {
              KeepAlive = true;
              # Program = "${cfg.package}/bin/act_runner"
              RunAtLoad = true;
              StandardErrorPath = "/var/log/forgejo-runner-${name}.log";
              StandardOutPath = "/var/log/forgejo-runner-${name}.log";
              UserName = "forgejo-runner";
              WatchPaths = lib.optionals (instance.tokenFile != null) [ instance.tokenFile ];

              WorkingDirectory = "/var/lib/forgejo-runner";
            };
          };
      in
      mapAttrs' mkRunnerService cfg.instances;

    system.activationScripts.preActivation.text = ''
      ${builtins.concatStringsSep "\n" (
        builtins.map (i: "touch /var/log/forgejo-runner-${i}.log") (builtins.attrNames cfg.instances)
      )}
      chown ${toString user.uid}:${toString user.gid} /var/log/forgejo-runner-*.log
    '';

    nix.settings.trusted-users = [ "forgejo-runner" ];
    users.knownGroups = [ "forgejo-runner" ];
    users.knownUsers = [ "forgejo-runner" ];

    users.users.forgejo-runner = {
      isHidden = true;
      uid = lib.mkDefault 398;
      gid = lib.mkDefault config.users.groups.forgejo-runner.gid;
      home = lib.mkDefault "/var/lib/forgejo-runner";
      name = "forgejo-runner";
      createHome = true;
      shell = "/bin/bash";
    };

    users.groups.forgejo-runner = {
      gid = lib.mkDefault 32002;
      name = "forgejo-runner";
    };
  };
}
