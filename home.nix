{
  config,
  pkgs,
  lib,
  pkgs-unstable,
  ...
}:
{
  imports = [ ./modules ];

  myhome.niri.enable = true;
  myhome.toys.enable = true;
  myhome.devtools.enable = true;
  myhome.kak.enable = true;
  myhome.flatpak.enable = true;
  myhome.dropbox.enable = true;

  # myhome.colors.colorscheme = "nord";
}
