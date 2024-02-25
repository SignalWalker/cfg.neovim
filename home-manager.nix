inputs @ {self, ...}: {
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  ash = config.programs.ashvim;
  nvim = config.programs.neovim;
in {
  options = with lib; {
    programs.ashvim = {
      enable = mkEnableOption "Ash Walker's Neovim configuration";
      package = mkPackageOption pkgs "neovim-unwrapped" {};
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf ash.enable (lib.mkMerge [
    {
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        defaultEditor = true;
        extraPackages = with pkgs; [
          tree-sitter
          glow
          fzf
          lua-language-server
          imagemagick # 3rd/image.nvim
          delta # debugloop/telescope-undo.nvim
          vscode-extensions.vadimcn.vscode-lldb.adapter # nvim-dap
          graphviz # rustaceanvim
          stylua # lua formatting
          taplo # toml formatting
        ];
        # python
        withPython3 = true;
        extraPython3Packages = pyPkgs: [];
        # lua
        extraLuaPackages = luaPkgs: [
          luaPkgs.magick # 3rd/image.nvim
        ];

        coc.enable = false;
      };
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
