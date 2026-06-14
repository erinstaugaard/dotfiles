{
  pkgs,
  config,
  lib,
  pkgs-unstable,
  ...
}:
with builtins;
with lib;
{
  options.myhome.maestral = {
    enable = mkOption {
      description = "enable maestral";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.maestral.enable {
    home.packages = with pkgs; [ pkgs-unstable.maestral ];

    systemd.user.services.maestral = {
      Unit = {
        Description = "Dropbox service";
        Wants = [ "waybar" ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs-unstable.maestral}/bin/maestral";
        Restart = "on-failure";
      };
    };
  };
}
