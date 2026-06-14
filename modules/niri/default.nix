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
  options.myhome.niri = {
    enable = lib.mkOption {
      description = "enable niri";
      type = lib.types.bool;
      default = false;
    };
    keyboard-layout = lib.mkOption {
      description = "keyboard layout for niri";
      type = lib.types.str;
      default = "us,us";
    };
    keyboard-variant = lib.mkOption {
      description = "keyboard layout variant for niri";
      type = lib.types.str;
      default = "dvorak,dvorak-intl";
    };
  };

  config = mkIf config.myhome.niri.enable {
    programs.niri.package = pkgs.niri-stable;

    home.packages = with pkgs; [
      xwayland-satellite
    ];

    programs.niri.settings = import ./settings.nix {
      inherit pkgs;
      inherit config;
      inherit lib;

      keyboard-layout = config.myhome.niri.keyboard-layout;
      keyboard-variant = config.myhome.niri.keyboard-variant;
    };

    myhome.desktop.enable = true;
  };
}
