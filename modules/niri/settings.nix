{
  config,
  pkgs,
  lib,
  keyboard-layout,
  keyboard-variant,
  ...
}:
let
  quick-launch-command = import ../quick-launch.nix {
    inherit config;
    inherit pkgs;
    inherit lib;
  };
in
with pkgs;
{
  input.keyboard.xkb = {
    layout = keyboard-layout;
    variant = keyboard-variant;
  };

  outputs = {
    "HDMI-A-1" = {
      position = {
        y = 0;
        x = 0;
      };
    };
    "HDMI-A-2" = {
      position = {
        y = 1440;
        x = 0;
      };
    };
  };

  workspaces = {
    browser = { };
    main = { };
    chat = { };
    recording = { };
    music = { };
  };

  binds = with config.lib.niri.actions; {
    "Mod+Ctrl+M".action = focus-workspace "main";
    "Mod+Ctrl+Shift+M".action.move-column-to-workspace = "main";
    "Mod+Ctrl+Space".action = spawn "niri" "msg" "action" "switch-layout" "next";

    "Mod+Ctrl+B".action = focus-workspace "browser";
    "Mod+Ctrl+Shift+B".action.move-column-to-workspace = "browser";

    "Mod+Ctrl+C".action = focus-workspace "chat";
    "Mod+Ctrl+Shift+C".action.move-column-to-workspace = "chat";

    "Mod+Ctrl+R".action = focus-workspace "recording";
    "Mod+Ctrl+Shift+R".action.move-column-to-workspace = "recording";

    "Mod+Ctrl+A".action = focus-workspace "music";
    "Mod+Ctrl+Shift+A".action.move-column-to-workspace = "music";

    "Mod+Shift+Slash".action = show-hotkey-overlay;
    "Mod+Shift+Return".action = spawn "kitty";
    "Mod+P".action = spawn "rofi" "-show" "drun" "-terminal" "kitty";
    "Super+Shift+C".action.screenshot = {
      show-pointer = false;
    };
    "Super+Shift+O".action = spawn "swaync-client" "-t" "-sw";
    "Super+O".action = spawn "${quick-launch-command}/bin/launcher";
    # spawn "${pkgs.gtk-quick-launch}/bin/quick-launch" "--config" "${./config.json}" "--css"
    #   "${quick-launch-style}";
    "Super+Shift+L".action = spawn "swaylock"; # "--image" "${config.programs.swaylock.settings.image}";

    "Mod+R".action = switch-preset-column-width;
    "Mod+Shift+R".action = switch-preset-window-height;
    "Mod+F".action = maximize-column;
    "Mod+Shift+F".action = fullscreen-window;
    "Mod+C".action =
      spawn "rofi" "-show" "calc" "-modi" "calc" "-modi" "emoji" "-no-persist-history" "-calc-command"
        "echo -n '{result}' | ${pkgs.wl-clipboard}/bin/wl-copy";

    "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+";
    "XF86AudioRaiseVolume".allow-when-locked = true;

    "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
    "XF86AudioLowerVolume".allow-when-locked = true;

    "XF86MonBrightnessDown".action =
      spawn "bash" "-c"
        "${brightnessctl}/bin/brightnessctl -c backlight set 1- && ${libnotify}/bin/notify-send -c \"system\" \" Brightness: $(${brightnessctl}/bin/brightnessctl -m | cut -d',' -f4)\"";
    "XF86MonBrightnessDown".allow-when-locked = true;

    "XF86MonBrightnessUp".action =
      spawn "bash" "-c"
        "${brightnessctl}/bin/brightnessctl -c backlight set +1 && ${libnotify}/bin/notify-send -c \"system\" \" Brightness: $(${brightnessctl}/bin/brightnessctl -m | cut -d',' -f4)\"";
    "XF86MonBrightnessUp".allow-when-locked = true;

    "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
    "XF86AudioMute".allow-when-locked = true;

    "XF86AudioMicMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
    "XF86AudioMicMute".allow-when-locked = true;

    "Mod+Shift+W".action = close-window;

    "Mod+H".action = focus-column-left;
    "Mod+T".action = focus-window-down;
    "Mod+N".action = focus-window-up;
    "Mod+S".action = focus-column-right;

    "Mod+Shift+H".action = move-column-left;
    "Mod+Shift+T".action = move-window-down;
    "Mod+Shift+N".action = move-window-up;
    "Mod+Shift+S".action = move-column-right;

    "Mod+Home".action = focus-column-first;
    "Mod+End".action = focus-column-last;
    "Mod+Ctrl+Home".action = move-column-to-first;
    "Mod+Ctrl+End".action = move-column-to-last;

    "Mod+J".action = focus-workspace-down;
    "Mod+K".action = focus-workspace-up;
    "Mod+Shift+J".action = move-column-to-workspace-down;
    "Mod+Shift+K".action = move-column-to-workspace-up;

    "Mod+WheelScrollDown".action = focus-workspace-down;
    "Mod+WheelScrollDown".cooldown-ms = 150;

    "Mod+A".action = toggle-overview;

    "Mod+WheelScrollUp".action = focus-workspace-up;
    "Mod+WheelScrollUp".cooldown-ms = 150;

    "Mod+Ctrl+WheelScrollDown".action = move-column-to-workspace-down;
    "Mod+Ctrl+WheelScrollDown".cooldown-ms = 150;

    "Mod+Ctrl+WheelScrollUp".action = move-column-to-workspace-up;
    "Mod+Ctrl+WheelScrollUp".cooldown-ms = 150;

    "Mod+WheelScrollRight".action = focus-column-right;
    "Mod+WheelScrollLeft".action = focus-column-left;
    "Mod+Ctrl+WheelScrollRight".action = move-column-right;
    "Mod+Ctrl+WheelScrollLeft".action = move-column-left;

    "Mod+Shift+WheelScrollDown".action = focus-column-right;
    "Mod+Shift+WheelScrollUp".action = focus-column-left;
    "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
    "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;

    "Mod+Comma".action = consume-window-into-column;
    "Mod+Period".action = expel-window-from-column;

    "Mod+BracketLeft".action = consume-or-expel-window-left;
    "Mod+BracketRight".action = consume-or-expel-window-right;

    "Mod+Minus".action = set-column-width "-10%";
    "Mod+Equal".action = set-column-width "+10%";

    "Mod+Shift+Minus".action = set-window-height "-10%";
    "Mod+Shift+Equal".action = set-window-height "+10%";

    "Print".action.screenshot = {
      show-pointer = false;
    };

    "Mod+Shift+Q".action =
      let
        css = pkgs.writeText "style.css" ''
          label {
                color: #${config.lib.stylix.colors.base05};
                background-color: #${config.lib.stylix.colors.base01};
                padding: 20px;

                border: 2px solid #${config.lib.stylix.colors.base0E};
                border-radius: 20px;
          }

          window {
              background-color: #00000000;

          }
        '';
      in
      spawn "${pkgs.gtk-confirmation-dialog}/bin/confirmation" "-s" "${
        css
      }" "--message" "Are you sure you want to quit niri?" "-c" "niri msg action quit -s";

    "Mod+Q".action =

      let
        css = pkgs.writeText "style.css" ''
          window {
              background-color: #00000000;
          }

          box {
              background-color: #${config.lib.stylix.colors.base01};
              border-radius: 20px;
              padding: 20px;
              border: 2px solid #${config.lib.stylix.colors.base0E};
          }
        '';
      in
      spawn "bash" "-c"
        "${pkgs.wl-clipboard}/bin/wl-paste | ${pkgs.qrencode}/bin/qrencode -s 50 -o - | ${pkgs.display-image}/bin/display-image --image - --css ${css} --size 800";

    "Mod+V".action = switch-focus-between-floating-and-tiling;
    "Mod+Shift+V".action = toggle-window-floating;
  };

  gestures.hot-corners.enable = false;

  screenshot-path = "~/Dropbox/Screenshots/Screenshot %Y-%m-%d at %H:%M:%S.png";
  prefer-no-csd = true;
  spawn-at-startup = [
    (
      let
        background_file = pkgs.replaceVars ./set_bg.fish {
          background_image = config.stylix.image;
        };
      in
      {
        command = [
          "${pkgs.fish}/bin/fish"
          "${background_file}"
        ];
      }
    )
    # { command = [ "${pkgs.xwayland-satellite}/bin/xwayland-satellite" ]; }
    {
      command = [
        "dbus-update-activation-environment"
        "DISPLAY"
      ];
    }
  ];

  input.focus-follows-mouse.enable = true;
  input.focus-follows-mouse.max-scroll-amount = "25%";
  input.warp-mouse-to-focus.enable = true;

  window-rules = [
    {
      geometry-corner-radius = {
        bottom-left = 20.0;
        bottom-right = 20.0;
        top-left = 20.0;
        top-right = 20.0;
      };
      clip-to-geometry = true;
      open-on-workspace = "main";
    }

    {
      matches = [
        { app-id = "^Bitwarden$"; }
        { app-id = "^vesktop$"; }
      ];
      block-out-from = "screen-capture";
    }

    {
      matches = [
        {
          app-id = "^librewolf$";
        }
        {
          app-id = "^io.github.celluloid_player.Celluloid$";
        }
      ];
      open-on-workspace = "browser";
      default-column-width = {
        proportion = 1.0;
      };
    }

    {
      matches = [
        {
          app-id = "^spotify$";
        }
      ];
      default-column-width = {
        proportion = 1.0;
      };
      open-on-workspace = "music";
    }

    {
      matches = [
        {
          app-id = "^vesktop$";
        }
        {
          app-id = "^Signal$";
        }
        {
          app-id = "^org.gnome.Evolution$";
        }
      ];
      default-column-width = {
        proportion = 1.0;
      };
      open-on-workspace = "chat";
    }

    {
      matches = [
        {
          app-id = "^com.obsproject.Studio$";
        }
      ];
      default-column-width = {
        proportion = 1.0;
      };
      open-on-workspace = "recording";
    }
  ];

  overview.backdrop-color = "#${config.lib.stylix.colors.base01}";

  layer-rules = [
    {
      matches = [
        { namespace = "swaync-notification-window"; }
        { namespace = "swaync-control-center"; }
      ];
      block-out-from = "screen-capture";
    }
  ];

  layout = {
    focus-ring = {
      enable = true;
      width = 2;
      active.color = "#${config.lib.stylix.colors.base07}";
      inactive.color = "#${config.lib.stylix.colors.base01}";
    };

    always-center-single-column = true;

    default-column-width = {
      proportion = 0.5;
    };

    gaps = 10;

    preset-column-widths = [
      { proportion = 0.333333333333; }
      { proportion = 0.5; }
      { proportion = 0.666666666666; }
    ];
  };

  cursor.size = 24;

  environment = {
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    GTK_USE_PORTAL = "0";
    WLR_RENDERER = "vulkan";
  };
}
