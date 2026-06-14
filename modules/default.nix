{
  pkgs,
  config,
  lib,
  tools,
  ...
}:
{
  imports = [
    ./devtools.nix
    ./toys.nix
    ./rofi.nix
    ./kak.nix
    ./fish.nix
    ./kitty.nix
    ./niri
    ./swaync.nix
    ./desktop.nix
    ./flatpak.nix
    ./colors.nix
    ./dropbox.nix
    ./waybar.nix
  ];

  options = {
    myhome.username = lib.mkOption {
      description = "username to use in home-manager";
      type = lib.types.str;
      default = "a";
    };
  };

  config = {
    home = {
      username = config.myhome.username;
      homeDirectory = "/home/${config.myhome.username}";
    };

    stylix.overlays.enable = false;

    home = {
      packages = with pkgs; [
        # always
        bc
        unzip
        git
        qrcp
        caligula
        trash-cli

        (tools.make_commands_script {
          inherit pkgs;
          options = {
            system = ''
              pushd ~/dotfiles
              sudo nixos-rebuild switch --flake "."
              popd
            '';
            update = ''
              pushd ~/dotfiles
              git pull origin main
              sudo nixos-rebuild switch --flake "."
              ssh root@69.48.200.159 "apt-get update; apt-get upgrade"
              popd
            '';
            collect-garbage = ''
              nix-collect-garbage -d
              sudo nix-collect-garbage -d
              nix-store --optimise
            '';
            update-button = ''
              kitty bash -c 'system update; fish' &
              disown -a
            '';
            build-iso = ''
              pushd ~/dotfiles
              nix build .#nixosConfigurations.iso.config.system.build.isoImage
              popd
            '';
            deploy = ''
              pushd ~/dotfiles
              nixos-rebuild switch --target-host "nixos@169.254.90.188" --use-remote-sudo --flake ".#rpi-home"
              popd
            '';
          };
          name = "system";
        })
      ];

      sessionVariables.LS_COLORS = "di=36;40:ln=0";
    };

    programs.git = {
      enable = true;

      settings = {
        user = {
          email = "astaugaard@icloud.com";
          name = "Erin Staugaard";
        };
      };
    };

    xdg.enable = true;

    home.stateVersion = "23.11";

    programs.home-manager.enable = true;
  };
}
