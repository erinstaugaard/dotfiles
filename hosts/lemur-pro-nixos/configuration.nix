# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  pkgs-unstable,
  tools,
  stylix,
  niri,
  nix-index-database,
  nix-flatpak,
  ...
}:

# let mypkgs = import ./myPackages pkgs;
# in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disko.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs.tools = tools;
  home-manager.extraSpecialArgs.pkgs-unstable = pkgs-unstable;
  home-manager.useUserPackages = true;

  home-manager.users.a = {
    imports = [
      ../../home.nix
      stylix.homeModules.stylix
      nix-flatpak.homeManagerModules.nix-flatpak
      nix-index-database.homeModules.default
    ];
  };

  # specialisation = {
  #   light.configuration = {
  #     home-manager.users.a.imports = [
  #       {
  #         myhome.colors = {
  #           dark = false;
  #           colorscheme = "catppuccin-latte";
  #         };
  #       }
  #     ];
  #   };
  # };

  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "dvorak";
  console.useXkbConfig = true;

  i18n.defaultLocale = "en_US.UTF-8";
  networking.hostName = "lemur-pro-nixos";
  time.timeZone = "America/New_York";

  mysystem.enablegc = true;
  mysystem.flatpak.enable = true;
  mysystem.niri = true;
  mysystem.user = "a";
  mysystem.userdescription = "estaugaard";
  mysystem.wpasupplicant.enable = true;
  mysystem.virt = false;
  mysystem.ssh.enable = true;
  mysystem.aarch-binfmt = false;
  mysystem.printing = true;

  mysystem.grub = true;
  mysystem.systemd-boot = false;
  mysystem.steam = true;
  mysystem.bluetooth = true;

  mysystem.dev.enable = true;

  hardware.system76.enableAll = true;
}
