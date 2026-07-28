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
      {
        myhome.niri.keyboard-layout = "us";
        myhome.niri.keyboard-variant = "qwerty";
      }
      {
        myhome.dropbox.enable = true;
      }
    ];
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.networkmanager.enable = true;
  # networking.wireless.iwd.enable = true;
  # networking.networkmanager.wifi.backend = "iwd";

  #  networking.wireless.enable = false

  # services.displayManager.sddm.enable = false;
  # services.displayManager.sddm.wayland.enable = true;
  # services.displayManager.defaultSession = "none+xmonad";

  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  i18n.defaultLocale = "en_US.UTF-8";
  networking.hostName = "nixos";
  time.timeZone = "America/New_York";

  mysystem.enablegc = true;
  mysystem.flatpak.enable = true;
  # mysystem.tailscale.enable = true;
  mysystem.niri = true;
  mysystem.amd = true;
  mysystem.user = "a";
  mysystem.userdescription = "astaugaard";
  mysystem.wpasupplicant.enable = true;
  mysystem.virt = false;
  mysystem.ssh.enable = true;

  mysystem.dev.enable = true;

  mysystem.grub = true;
  mysystem.systemd-boot = false;
  mysystem.steam = true;
}
