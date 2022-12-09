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
  nvim = config.programs.neovim;
in {
  options = with lib; {
    programs.neovim = {
      enable = mkEnableOption "Ash Walker's Neovim configuration";
      package = mkPackageOption "neovim";
    };
  };
  disabledModules = [<home-manager/modules/programs/neovim.nix>];
  imports = [];
  config = lib.mkIf nvim.enable (lib.mkMerge [
    {
      home.packages =
        [nvim.package]
        ++ (with pkgs; [
          tree-sitter
        ]);
      xdg.configFile."nvim" = {
        source = toString self;
        recursive = false;
      };
    }
    (lib.mkIf (config ? signal.dev.editor.editors) {
      signal.dev.editor.editors."neovim" = {
        cmd.term = "nvim";
      };
    })
  ]);
  meta = {};
}
