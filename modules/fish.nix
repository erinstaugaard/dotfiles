{
  pkgs,
  config,
  lib,
  ...
}:
with builtins;
with lib;
{
  options.myhome.fish = {
    enable = mkOption {
      description = "enable fish";
      type = lib.types.bool;
      default = true;
    };
  };

  config = mkIf config.myhome.fish.enable {
    stylix.targets.fish.enable = false;

    home.shell.enableFishIntegration = true;

    programs.zoxide.enable = true;

    programs.nix-index.enable = true;

    programs.fish = {
      enable = true;
      functions = {
        fish_prompt = ''
          if fish_is_root_user
              set div ""
          else 
              set div ""
          end
          set_color -b green; set_color -o black; 
          echo (date "+%H:%M:%S")(set_color -b cyan; set_color -o green)$div(set_color normal; set_color -o black; set_color -b cyan) (prompt_pwd)(set_color -b magenta; set_color cyan)$div(set_color normal ; set_color -o black; set_color -b magenta) (echo $CMD_DURATION)ms(set_color normal; set_color -o black; set_color magenta)$div(set_color normal)" "
        '';

        fish_greeting = "";

        fish_default_mode_prompt = ''
          echo ""
        '';
      };

      interactiveShellInit = ''
        fish_vi_key_bindings --no-erase
        bind -M insert \cf accept-autosuggestion
      '';

      shellInit = ''
        fish_add_path ~/.bin/ ~/.local/bin/ ~/.pack/bin/
      '';

      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../../";
        c = "clear";
        ll = "ls -FGghot";
        la = "ls -FGghotA";
        t = "trash";
      };
    };
  };
}
