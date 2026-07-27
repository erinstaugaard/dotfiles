{
  pkgs,
  config,
  lib,
}:
let
  launch-config = pkgs.writeText "config.json" (
    lib.generators.toJSON { } {
      width = 4;
      height = 4;
      icon_size = 64;
      applications = {
        "l" = {
          application = "librewolf";
        };

        "f" = {
          application = "org.gnome.Nautilus";
          command = "nautilus";
          image = pkgs.fetchurl {
            url = "https://gitlab.gnome.org/uploads/-/system/project/avatar/1/bitmap.png?width=48";
            hash = "sha256-Ub7RpIyFpUnvashX1Qvx+wc6/RwSaBJqIlGiDC/T9Y8=";
            name = "nautilus-icon";
          };
        };

        "v" = {
          application = "dev.vencord.Vesktop";
        };

        "c" = {
          application = "bluetui-desktop";
        };

        "g" = {
          application = "net.lutris.Lutris";
        };

        "b" = {
          application = "com.bitwarden.desktop";
        };

        "t" = {
          application = "org.mozilla.thunderbird_esr";
        };

        "o" = {
          application = "com.obsproject.Studio";
        };

        "p" = {
          application = "org.prismlauncher.PrismLauncher";
          image = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/icon/1a840cbe152165dc045e90d67071b96a.png";
            hash = "sha256-+5eLSr4LHPS4JToSzaF2QjsJZXOmcDl8ZwRbMXpb4bw=";
            name = "prism-icon";
          };
        };

        "s" = {
          application = "com.spotify.Client";
          image = pkgs.fetchurl {
            url = "https://storage.googleapis.com/pr-newsroom-wp/1/2023/05/Spotify_Primary_Logo_RGB_Green.png";
            hash = "sha256-GT7289I22poeHimRv0SnWggvs8mSVcnuybR+pfZkE/E=";
            name = "spotify-icon";
          };
        };

        "S" = {
          application = "org.signal.Signal";
          image = pkgs.fetchurl {
            url = "https://imgproxy.flathub.org/insecure/dpr:2/f:avif/q:100/rs:fit:128:128/aHR0cHM6Ly9kbC5mbGF0aHViLm9yZy9tZWRpYS9vcmcvc2lnbmFsL1NpZ25hbC9lODUzNjZlOWEyNzI4Y2UyNDhlMzFjY2NhYTgwMWVhNS9pY29ucy8xMjh4MTI4L29yZy5zaWduYWwuU2lnbmFsLnBuZw";
            hash = "sha256-/deCvkgJdiqQoYVIHIKgLvecDE1pT3tc9igYUXG6jaU=";
            name = "signal-icon";
          };
        };

        "d" = {
          name = "Editors";
          image = pkgs.fetchurl {
            url = "https://cdn-icons-png.flaticon.com/512/4400/4400968.png";
            hash = "sha256-FnhvV0gx0tooI9rQn7oHyq7QTnVVJGjZMoYDmJVyZYE=";
            name = "editors-icon";
          };
          applications = {
            "b" = {
              application = "org.blender.Blender";
              image =
                let
                  logos_kit = pkgs.fetchzip {
                    url = "https://download.blender.org/branding/blender_logo_kit.zip";
                    hash = "sha256-xnr5j/z3JdQnqMbm1GwQKMnriqxTEKlLZZxYYne6Bo0=";
                    name = "blender-logo-kit";
                  };
                in
                "${logos_kit}/square/blender_icon_64x64.png";
            };

            "i" = {
              application = "org.inkscape.Inkscape";
            };

            "c" = {
              name = "Calc";
              application = "org.libreoffice.LibreOffice.calc";
            };

            "d" = {
              name = "Draw";
              application = "org.libreoffice.LibreOffice.draw";
            };

            "s" = {
              name = "Slides";
              application = "org.libreoffice.LibreOffice.impress";
            };

            "m" = {
              name = "Math";
              application = "org.libreoffice.LibreOffice.math";
            };

            "w" = {
              name = "Docs";
              application = "org.libreoffice.LibreOffice.writer";
            };
          };
        };
      };
    }
  );
  css = pkgs.writeText "style.css" ''
    window {
        background-color: #00000000;

    }

    stack {
        background-color: #${config.lib.stylix.colors.base01};
        border-radius: 20px;
        padding: 20px;
        border: 2px solid #${config.lib.stylix.colors.base0E};
    }

    button {
        background-color: #${config.lib.stylix.colors.base02};
        color: #${config.lib.stylix.colors.base05};
        border-radius: 20px;
        padding: 20px;
    }
  '';
in
(pkgs.writeShellScriptBin "launcher" ''
  ${pkgs.gtk-quick-launch}/bin/quick-launch --config ${launch-config} --css ${css}
'')
