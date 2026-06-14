{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  i18n.defaultLocale = "en_US.UTF-8";
  networking.hostName = "rpi-home";
  time.timeZone = "America/New_York";
  mysystem.user = "nixos";
  mysystem.userdescription = "admin";

  boot.kernel.sysctl = {
    "vm.swappiness" = 60;
  };

  boot.kernelParams = [
    "cgroup_memory=1"
    "cgroup_enable=memory"
  ];

  # networking = {
  #   interfaces.end0 = {
  #     addresses = [
  #       {
  #         address = "169.254.90.188";
  #         prefixLength = 24;
  #       }
  #     ];
  #   };
  # };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  mysystem.enablegc = true;
  mysystem.wpasupplicant.enable = true;
  mysystem.ssh.enable = true;
  mysystem.wireguard-host.enable = true;
  mysystem.invidious.enable = true;
  mysystem.pixelfed.enable = false;

  mysystem.freshrss.enable = true;

  mysystem.systemd-boot = false;
  mysystem.grub = false;
  mysystem.grub-device = "/dev/mmcblk0";
}
