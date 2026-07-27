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
  options.mysystem = {
    sway = mkOption {
      description = "enable sway system stuff";
      type = lib.types.bool;
      default = false;
    };
    niri = mkOption {
      description = "enable niri system stuff";
      type = lib.types.bool;
      default = false;
    };
    xmonad = mkOption {
      description = "enable xmonad system stuff";
      type = lib.types.bool;
      default = false;
    };
    xserver = mkOption {
      description = "enable x11 system stuff";
      type = lib.types.bool;
      default = config.mysystem.xmonad;
    };
    gui = mkOption {
      description = "enable common gui components";
      type = lib.types.bool;
      default = config.mysystem.niri || config.mysystem.sway || config.mysystem.xmonad;
    };
    loginManager = mkOption {
      description = "enable login manager";
      type = lib.types.bool;
      default = config.mysystem.gui;
    };
    steam = mkOption {
      description = "enable steam";
      type = lib.types.bool;
      default = false;
    };
    printing = mkOption {
      description = "enable printing support";
      type = lib.typs.bool;
      default = false;
    };
  };

  config = mkIf config.mysystem.gui {
    environment.systemPackages = with pkgs; [
      catppuccin-gtk
      beauty-line-icon-theme
      xterm
    ];

    services.printing.enable = true;

    # programs.gamescope = {
    #   enable = config.mysystem.steam;
    #   capSysNice = true;
    # };

    programs.steam = {
      enable = config.mysystem.steam;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers

      gamescopeSession = {
        enable = true;
      };
    };

    boot = {
      initrd.systemd.enable = true;

      plymouth = {
        enable = true;
        theme = "rings_2";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = [ "rings_2" ];
          })
        ];
      };

      kernelParams = [
        "boot.shell_on_fail"
        "plymouth.use-simpledrm"
      ];
    };

    programs.dconf.enable = true;
    security.rtkit.enable = true;

    programs.sway.enable = config.mysystem.sway;
    programs.sway.package = pkgs.sway;

    programs.niri.enable = config.mysystem.niri;
    niri-flake.cache.enable = false;

    programs.xwayland.enable = true;

    fonts = {
      packages = with pkgs; [ nerd-fonts.fira-code ];
      fontconfig = {
        defaultFonts = {
          monospace = [ "FiraCode" ];
        };
      };
    };

    services.xserver = {
      # xkb.variant= "dvorak";
      enable = config.mysystem.xserver;
      windowManager = {
        xmonad = {
          enable = config.mysystem.xmonad;
        };
      };
    };

    programs.egui-greeter = {
      enable = config.mysystem.loginManager;
      default_session_name = "Niri";

      default_session_command = "niri-session";

      user = config.mysystem.user;
    };

    services.pipewire = {
      enable = true;
      audio.enable = true;
      package = pkgs.pipewire;
      systemWide = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
        extraConfig = {
          "monitor.bluez.properties" = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;
            "bluez5.roles" = [
              "hsp_hs"
              "hsp_ag"
              "hfp_hf"
              "hfp_ag"
            ];
          };
        };
      };
    };

    hardware.graphics.enable32Bit = true;
    hardware.graphics.enable = true;
    hardware.graphics.package = pkgs.mesa;
  };
}
