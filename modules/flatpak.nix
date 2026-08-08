{
  pkgs,
  config,
  lib,
  pkgs-unstable,
  ...
}:
with lib;
{
  options.myhome.flatpak = {
    enable = mkOption {
      description = "enable flatpak";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.flatpak.enable {
    home.packages = with pkgs; [
      flatpak
      warehouse
    ];

    services.flatpak.enable = true;

    services.flatpak.packages = [
      "com.bitwarden.desktop"
      "com.github.tchx84.Flatseal"
      # "com.github.unrud.VideoDownloader"
      "com.obsproject.Studio"
      "com.spotify.Client"
      "dev.vencord.Vesktop"
      # "io.bassi.Amberol"
      # "io.github.wxmaxima_developers.wxMaxima"
      "net.lutris.Lutris"
      "org.blender.Blender"
      "org.gimp.GIMP"
      "org.inkscape.Inkscape"
      "org.libreoffice.LibreOffice"
      "org.mozilla.Thunderbird"
      "org.torproject.torbrowser-launcher"
      "org.prismlauncher.PrismLauncher"
      "in.cinny.Cinny"
      "com.github.johnfactotum.Foliate"
      "org.signal.Signal"
      "net.ankiweb.Anki"
      "org.texstudio.TeXstudio"
      "org.freedesktop.Sdk.Extension.texlive//25.08"
      "us.zoom.Zoom"
      "net.trowell.typesetter"
    ];

    services.flatpak.uninstallUnmanaged = true;
    services.flatpak.update.onActivation = true;

    xdg.systemDirs.data = [
      "/usr/share"
      "/var/lib/flatpak/exports/share"
      "~/.local/share/flatpak/exports/share"
    ];
  };
}
