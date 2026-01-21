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
          extraPackages = [
            pkgs.luarocks # lazy-rocks
            pkgs.lua5_1 # lazy-rocks

            pkgs.ripgrep # multi
            pkgs.fd # multi

            pkgs.universal-ctags

            pkgs.tree-sitter
            pkgs.nodejs_latest # treesitter
            pkgs.clang # treesitter, others # TODO :: what others

            pkgs.glow # markdown previews
            pkgs.fzf # TODO :: ???

            # pkgs.cargo # blink.nvim, rustowl
            # pkgs.cargo-binstall # rustowl

            # pkgs.cmake # telescope-fzf-native
            # pkgs.gnumake # telescope-fzf-native

            pkgs.imagemagick # 3rd/image.nvim
            pkgs.delta # debugloop/telescope-undo.nvim
            pkgs.graphviz # rustaceanvim
            pkgs.taplo # toml formatting / language server
            pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter # nvim-dap

            pkgs.nixd # nix language server
            pkgs.nixfmt-rfc-style
            pkgs.statix # nix linter

            pkgs.tailwindcss-language-server # css language server

            pkgs.vscode-langservers-extracted # json, among other things

            pkgs.cmake-language-server

            pkgs.lua-language-server
            pkgs.stylua # lua formatting

            pkgs.eslint
            pkgs.typescript-language-server

            # snacks.nvim
            pkgs.sqlite # picker
            pkgs.gh # github functions

            pkgs.stylelint

            pkgs.csharp-ls
            pkgs.csharpier # C# formatter

            pkgs.atac # REST API testing

            pkgs.tectonic # latex math rendering
            pkgs.mermaid-cli # mermaid diagram rendering

            pkgs.dotnet-runtime # conform
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
