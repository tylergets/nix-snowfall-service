{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  namespace,
  system,
  target,
  format,
  virtual,
  systems,
  # All other arguments come from the module system.
  config,
  ...
}:
with lib; let
  cfg = config.services.helloNixosTests;
in {
  #### Module Options
  options = {
    services.helloNixosTests = {
      enable = mkEnableOption "helloNixosTests";

      user = mkOption {
        type = types.str;
        default = "hello";
        description = "The user to run the helloNixosTests service as.";
      };

      group = mkOption {
        type = types.str;
        default = "hello";
        description = "The group to run the helloNixosTests service as.";
      };

      port = mkOption {
        type = types.int;
        default = 3000;
        description = "The port for helloNixosTests, passed via BUN_PORT.";
      };
    };
  };

  #### Implementation
  config = mkIf cfg.enable {
    # Create the group. Adjust GID as needed or remove if you want to rely on dynamic assignment.
    users.groups."${cfg.group}".gid = 1000;

    # Create the user, referencing our newly added option values
    users.users."${cfg.user}" = {
      createHome = true;
      description = "helloNixosTests user";
      isSystemUser = true;
      group = cfg.group;
      home = "/var/lib/helloNixosTests";
    };

    # Systemd service
    systemd.services.helloNixosTests = {
      description = "helloNixosTests server";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      script = ''
        exec ${inputs.self.packages.${system}.default}/bin/hello-nixos-tests
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        RestartSec = "30s";

        # Pass the port via BUN_PORT
        Environment = [
          "PORT=${toString cfg.port}"
        ];
      };
    };
  };
}
