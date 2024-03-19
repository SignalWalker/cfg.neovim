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
      configPath = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      vscodeExtensions = mkOption {
        type = types.listOf types.package;
        default = [
        ];
      };
      vscodeExtDir = mkOption {
        type = types.str;
        readOnly = true;
        default = "${config.xdg.dataHome}/vscode/extensions";
      };
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf ash.enable (lib.mkMerge [
    {
      programs.ashvim = {
        vscodeExtensions = [
          pkgs.vscode-extensions.vadimcn.vscode-lldb # nvim-dap
        ];
      };
      home.file = {
        "${ash.vscodeExtDir}".source = let
          subDir = "share/vscode/extensions";
          combinedExtDrv = pkgs.buildEnv {
            name = "neovim-vscode-extensions";
            paths = ash.vscodeExtensions;
          };
        in "${combinedExtDrv}/${subDir}";
      };
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        defaultEditor = true;
        extraPackages = with pkgs; [
          tree-sitter
          glow # markdown previews
          fzf
          lua-language-server
          imagemagick # 3rd/image.nvim
          delta # debugloop/telescope-undo.nvim
          graphviz # rustaceanvim
          stylua # lua formatting
          taplo # toml formatting / language server
          vscode-extensions.vadimcn.vscode-lldb.adapter # nvim-dap
          nixd # nix language server
          tailwindcss-language-server # css language server
          vscode-langservers-extracted # json, among other things
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

      programs.kitty.extraConfig = ''
        # # vim-kitty-navigator
        # map kitty_mod+h
        # kitty-scrollback.nvim
        # action_alias kitty_scrollback_nvim kitten ${config.xdg.dataHome}/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py
        # map kitty_mod+/ kitty_scrollback_nvim
        # map kitty_mod+alt+/ kitty_scrollback_nvim --config ksb_builtin_last_cmd_output
      '';
    }
    (lib.mkIf (ash.configPath == null) {
      xdg.configFile."nvim" = {
        source = toString self;
        recursive = false;
      };
    })
    (lib.mkIf (ash.configPath != null) {
      home.activation."make-neovim-cfg-symlink" = lib.hm.dag.entryAfter ["WriteBoundary"] ''
        run rm $VERBOSE_ARG -- ${config.xdg.configHome}/nvim || true
        run ln -s $VERBOSE_ARG -T ${ash.configPath} ${config.xdg.configHome}/nvim
      '';
    })
    (lib.mkIf (config ? signal.dev.editor.editors) {
      signal.dev.editor.editors."neovim" = {
        cmd.term = "nvim";
      };
    })
  ]);
  meta = {};
}
