inputs @ {
  self,
  nixpkgs,
  ...
}: {
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  nvim = config.programs.ashvim;
in {
  options = with lib; {
    programs.ashvim = {
      enable = mkEnableOption "Ash Walker's Neovim configuration";
      package = mkOption {
        type = types.package;
        default = inputs.neovim.packages.${pkgs.system}.neovim;
      };
      settings = {
        enable = (mkEnableOption "install ashvim configuration") // {default = config.system.isNixOS or false;};
      };
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf nvim.enable (lib.mkMerge [
    {
      home.packages =
        [nvim.package]
        ++ (with pkgs; [
          tree-sitter
        ]);
    }
    (lib.mkIf (config ? signal.dev.editor.editors) {
      signal.dev.editor.editors."neovim" = {
        cmd.term = "nvim";
      };
    })
    (lib.mkIf nvim.settings.enable {
      xdg.configFile."nvim" = {
        source = toString self;
        recursive = false;
      };
    })
  ]);
  meta = {};
}
