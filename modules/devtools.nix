{
  pkgs,
  config,
  lib,
  pkgs-unstable,
  tools,
  ...
}:
with builtins;
with lib;
let
  myhelm = (
    with pkgs;
    wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    }
  );
  myhelmfile = pkgs.helmfile-wrapped.override {
    inherit (myhelm) pluginsDir;
  };
in
{
  options.myhome.devtools = {
    enable = mkOption {
      description = "enable toys";
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf config.myhome.devtools.enable {
    home.packages = with pkgs; [
      # kubectl
      # myhelm
      # myhelmfile

      # general c stuff (so most languages)
      pkg-config
      glib
      valgrind
      gcc
      lld
      gnumake

      # librsvg
      # libglvnd
      # gmp.dev

      # haskell
      # stack
      # ghc
      # haskell-language-server

      # misc
      # nodePackages.node2nix
      # chez

      nixfmt

      (
        let
          rust-script = pkgs.writeShellScriptBin "start-rust" ''
            kitty --detach bash -c "niri msg action focus-column-left; bacon"
            kak -e peneira-files
          '';

          typst-arrange = pkgs.writeShellScriptBin "typst-arrange" ''
            xdg-open $1 &
            sleep 1.0
            niri msg action focus-column-left
            niri msg action consume-window-into-column
            niri msg action set-window-height 33%
            niri msg action move-window-down
            niri msg action focus-column-left
          '';

          typst-make-live = pkgs.writeShellScriptBin "typst-make-live" ''
            typst watch $1 --open ${typst-arrange}/bin/typst-arrange
          '';

          typst-script = pkgs.writeShellScriptBin "start-typst" ''
            kitty --detach ${typst-make-live}/bin/typst-make-live $1
            kak $1
          '';
        in

        tools.make_commands_script {
          inherit pkgs;
          options = {
            rust = ''
              if ! nix develop --command ${rust-script}/bin/start-rust; then
                ${rust-script}/bin/start-rust
              fi
            '';
            typst = ''
              if ! nix develop --command ${typst-script}/bin/start-typst $1; then
                ${typst-script}/bin/start-typst $1
              fi
            '';
            config = ''
              cd ~/dotfiles
              kitty --detach
              kak
            '';
          };
          name = "start";
        }
      )

      # rust
      trunk
      pkgs-unstable.cargo
      pkgs-unstable.cargo-tarpaulin
      pkgs-unstable.rust-analyzer
      pkgs-unstable.clippy
      pkgs-unstable.cabal-install
      pkgs-unstable.rustfmt
      pkgs-unstable.bacon

      # typst
      pkgs-unstable.typst
      pkgs-unstable.typst-live
      pkgs-unstable.tinymist

      presenterm

      comma

      zotero
      # why3
      # creusot

      # coq
      # coqPackages.coqide

      # cargo-disasm # removed for now bc test not passing
    ];
  };
}
