{ self, ... }:
{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  ash = config.programs.ashvim;
in
{
  options = with lib; {
    programs.ashvim = {
      enable = mkEnableOption "Ash Walker's Neovim configuration";
      package = mkOption {
        type = types.package;
        # FIX :: restore neovim nightly (build error as of 2024-07-29)
        # default = inputs.neovim.packages.${pkgs.system}.neovim or pkgs.neovim-unwrapped;
        default = pkgs.neovim-unwrapped;
      };
      # package = mkPackageOption pkgs "neovim-unwrapped" {};
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
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkIf ash.enable (
    lib.mkMerge [
      {
        programs.ashvim = {
          vscodeExtensions = [
            pkgs.vscode-extensions.vadimcn.vscode-lldb # nvim-dap
          ];
        };
        home.file = {
          "${ash.vscodeExtDir}".source =
            let
              subDir = "share/vscode/extensions";
              combinedExtDrv = pkgs.buildEnv {
                name = "neovim-vscode-extensions";
                paths = ash.vscodeExtensions;
              };
            in
            "${combinedExtDrv}/${subDir}";
        };
        programs.neovim = {
          enable = true;
          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;
          defaultEditor = true;
          package = ash.package;
          extraPackages = with pkgs; [
            luarocks # lazy-rocks
            lua5_1 # lazy-rocks

            ripgrep # multi
            fd # multi

            universal-ctags

            tree-sitter
            nodejs_latest # treesitter
            clang # treesitter, others

            glow # markdown previews
            fzf

            cargo # blink.nvim

            cmake # telescope-fzf-native
            gnumake # telescope-fzf-native

            imagemagick # 3rd/image.nvim
            delta # debugloop/telescope-undo.nvim
            graphviz # rustaceanvim
            taplo # toml formatting / language server
            vscode-extensions.vadimcn.vscode-lldb.adapter # nvim-dap

            nixd # nix language server

            tailwindcss-language-server # css language server

            vscode-langservers-extracted # json, among other things

            trash-cli # nvim-tree trash

            cmake-language-server

            lua-language-server
            stylua # lua formatting

            eslint
            typescript-language-server

            # snacks.nvim
            sqlite # picker

            nixfmt-rfc-style

            stylelint

            csharp-ls
            csharpier # C# formatter

            atac # REST API testing

            tectonic # latex math rendering
            mermaid-cli # mermaid diagram rendering

            sqlite # snacks.picker frecency
          ];
          # python
          withPython3 = true;
          extraPython3Packages = pyPkgs: [ ];
          # lua
          extraLuaPackages = luaPkgs: [
            luaPkgs.magick # 3rd/image.nvim
          ];

          coc.enable = false;
        };

        programs.kitty.extraConfig = ''
          ## kitty-scrollback.nvim
          # action_alias kitty_scrollback_nvim kitten ${config.xdg.dataHome}/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py
          # map kitty_mod+/ kitty_scrollback_nvim
          # map kitty_mod+alt+/ kitty_scrollback_nvim --config ksb_builtin_last_cmd_output

          ## smart-splits.nvim
          map alt+h neighboring_window left
          map alt+j neighboring_window down
          map alt+k neighboring_window up
          map alt+l neighboring_window right

          map --when-focus-on var:IS_NVIM alt+h
          map --when-focus-on var:IS_NVIM alt+j
          map --when-focus-on var:IS_NVIM alt+k
          map --when-focus-on var:IS_NVIM alt+l

          map kitty_mod+h neighboring_window left
          map kitty_mod+j neighboring_window down
          map kitty_mod+k neighboring_window up
          map kitty_mod+l neighboring_window right

          map ctrl+h kitten relative_resize.py left  3
          map ctrl+j kitten relative_resize.py down  3
          map ctrl+k kitten relative_resize.py up    3
          map ctrl+l kitten relative_resize.py right 3

          map --when-focus-on var:IS_NVIM ctrl+h
          map --when-focus-on var:IS_NVIM ctrl+j
          map --when-focus-on var:IS_NVIM ctrl+k
          map --when-focus-on var:IS_NVIM ctrl+l

          map kitty_mod+alt+shift+h kitten relative_resize.py left  3
          map kitty_mod+alt+shift+j kitten relative_resize.py down  3
          map kitty_mod+alt+shift+k kitten relative_resize.py up    3
          map kitty_mod+alt+shift+l kitten relative_resize.py right 3

        '';
      }
      (lib.mkIf (ash.configPath == null) {
        xdg.configFile."nvim" = {
          source = toString self;
          recursive = false;
        };
      })
      (lib.mkIf (ash.configPath != null) {
        home.activation."make-neovim-cfg-symlink" = lib.hm.dag.entryAfter [ "WriteBoundary" ] ''
          run rm $VERBOSE_ARG -- ${config.xdg.configHome}/nvim || true
          run ln -s $VERBOSE_ARG -T ${ash.configPath} ${config.xdg.configHome}/nvim
        '';
      })
      (lib.mkIf (config ? signal.dev.editor.editors) {
        home.packages = with pkgs; [ httm ];
        signal.dev.editor.editors."neovim" = {
          cmd.term = "nvim";
        };
      })
    ]
  );
  meta = { };
}
