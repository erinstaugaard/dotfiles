{
  pkgs,
  config,
  lib,
  pkgs-unstable,
  ...
}:
with builtins;
with lib;
let
  lockscreen = pkgs.stdenv.mkDerivation rec {
    name = "lockscreen";
    src = lib.fileset.toSource {
      root = ./.;
      fileset = ./lock.svg;
    };
    foreground = "#${config.lib.stylix.colors.base09}";

    buildPhase = ''
      substituteAllInPlace lock.svg
    '';

    installPhase = ''
      mkdir $out

      ${pkgs.inkscape}/bin/inkscape --export-type "png" --export-filename "$out/lock.png" lock.svg
    '';
  };

in
{
  options.myhome.desktop = {
    enable = mkOption {
      description = "enable shared parts of the \"de\"";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.desktop.enable {
    home.packages = with pkgs; [
      xeyes
      ripgrep
      alsa-utils
      qrcp
      libqalculate
      libnotify
      nautilus
      beauty-line-icon-theme
      swaybg
      wl-clipboard
      celluloid
      evince
      eog

      (makeDesktopItem rec {
        name = "bluetui-desktop";
        desktopName = "Bluetui";
        exec = "${pkgs.kitty}/bin/kitty ${pkgs.bluetui}/bin/bluetui";
        icon = "bluetooth";
      })

      (makeDesktopItem rec {
        name = "impala-desktop";
        desktopName = "Impala";
        exec = "${pkgs.kitty}/bin/kitty ${pkgs.impala}/bin/impala";
        icon = "wireless";
      })

      (makeDesktopItem rec {
        name = "pairdrop";
        desktopName = "Pairdrop";
        exec = "${pkgs.chromium}/bin/chromium --app=\"https://pairdrop.net\"";
        icon = pkgs.fetchurl {
          url = "https://github.com/schlagmichdoch/PairDrop/raw/master/public/images/android-chrome-512x512.png";
          hash = "sha256-BGxMhMZwU0Gw6nA0TPn1ffr5x6HTmaJoymif+fM2KCI=";
          name = "pairdrop-icon";
        };
      })

      (makeDesktopItem rec {
        name = "wolfram_alpha";
        desktopName = "Wolfram Alpha";
        exec = "${pkgs.chromium}/bin/chromium --app=\"https://www.wolframalpha.com/\"";
        icon = pkgs.fetchurl {
          url = "https://img.icons8.com/?size=96&id=13667&format=png";
          hash = "sha256-gobtgTx9a/uBRcVBCgxMW95ebGHbGx3jLzBfyvbwbk0=";
          name = "wolfram-alpha-icon";
        };
      })

      (makeDesktopItem rec {
        name = "flathub";
        desktopName = "Flathub";
        exec = "${pkgs.chromium}/bin/chromium --app=\"https://flathub.org\"";
        icon = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/flathub-infra/assets/d593e566db996ec738621f073a13c534f681f291/web/favicon-i.svg";
          hash = "sha256-v2spj4xF5FXQcYonVIIMt3Di9Gu5OUX20KTxyPYPMoY=";
          name = "flathub-icon";
        };
      })

      (makeDesktopItem rec {
        name = "htop";
        desktopName = "htop";
        exec = "${pkgs.kitty}/bin/kitty ${pkgs.htop}/bin/htop";
        icon = "htop";
      })
    ];

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
    };

    programs.librewolf.enable = true;
    stylix.targets.librewolf.firefoxGnomeTheme.enable = true;
    stylix.targets.librewolf.enable = true;
    stylix.targets.librewolf.profileNames = [ "default" ];

    myhome.kitty.enable = true;
    myhome.rofi.enable = true;

    gtk.enable = true;
    gtk.iconTheme = {
      name = "BeautyLine";
      package = pkgs.beauty-line-icon-theme;
    };

    home.sessionVariables.WLR_RENDERER = "vulkan";

    myhome.waybar.enable = true;
    myhome.swaync.enable = true;

    stylix.targets.swaylock.useWallpaper = false;

    programs.swaylock.enable = true;
    programs.swaylock.package = pkgs.swaylock;

    services.swayidle = {
      enable = true;
      events.before-sleep = "${pkgs.swaylock}/bin/swaylock -fF";
      timeouts = [
        {
          timeout = 120;
          command = "${pkgs.niri-stable}/bin/niri msg action power-off-monitors";
        }
        {
          timeout = 180;
          command = "${pkgs.swaylock}/bin/systemctl hybrid-sleep";
        }
      ];
    };

    programs.swaylock.settings = {
      image = "${lockscreen}/lock.png";
    };
  };
}
