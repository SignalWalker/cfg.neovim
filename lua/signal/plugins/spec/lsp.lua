return {
	{
		"nvim-neotest/nvim-nio",
		lazy = true,
	},
	{
		"nvim-neotest/neotest",
		event = "LspAttach",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = function(_, _)
			return {
				adapters = {
					require("rustaceanvim.neotest"),
				},
			}
		end,
	},
	{
		"saecki/crates.nvim",
		dependencies = {},
		event = { "BufRead Cargo.toml" },
		opts = {
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
			neoconf = {
				enabled = false,
				namespace = "crates",
			},
		},
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false, -- handles laziness itself, apparently
		ft = { "rust" },
		init = function()
			vim.g.rustaceanvim = {
				tools = {
					reload_workspace_from_cargo_toml = true,
					hover_actions = {
						replace_builtin_hover = true,
					},
					code_actions = {
						ui_select_fallback = true,
					},
					test_executor = "background",
				},
				server = {
					standalone = false,
					default_settings = {
						["rust-analyzer"] = {
							imports = {
								prefix = "crate",
								granularity = {
									enforce = true,
									group = "crate",
								},
								merge = {
									glob = true,
								},
							},
							-- check = {
							-- 	command = "clippy",
							-- },
							diagnostics = {
								experimental = {
									enable = true,
								},
								styleLints = {
									enable = true,
								},
							},
							interpret = {
								tests = true,
							},
						},
					},
				},
			}
		end,
	},
	-- {
	-- 	"folke/neoconf.nvim",
	-- 	opts = {
	-- 		import = {
	-- 			vscode = true,
	-- 			coc = true,
	-- 			nlsp = true,
	-- 		},
	-- 	},
	-- },
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		"smjonas/inc-rename.nvim",
		event = { "LspAttach" },
		keys = {
			{
				"<Leader>sr",
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				desc = "rename lsp symbol",
				expr = true,
			},
		},
		opts = {},
	},
	{
		"slint-ui/vim-slint",
		enabled = false,
	},
	-- {
	-- 	"dgagn/diagflow.nvim",
	-- 	enabled = true,
	-- 	event = { "LspAttach" },
	-- 	opts = {
	-- 		scope = "line",
	-- 		show_borders = true,
	-- 		show_sign = false,
	-- 	},
	-- },
	{
		"RaafatTurki/corn.nvim",
		enabled = false,
		init = function()
			vim.diagnostic.config({ virtual_text = false })
		end,
		opts = {
			border_style = "double",
			on_toggle = function(is_hidden)
				vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
			end,
		},
	},
	{
		"https://gitlab.com/HiPhish/guile.vim",
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {},
		opts = {},
		config = function(_, opts)
			local lsp = require("lspconfig")

			opts["nixd"] = {
				root_dir = lsp.util.root_pattern(".nixd.json", "flake.nix"),
			}

			for srv, cfg in pairs(opts) do
				vim.lsp.config(srv, cfg)
			end
		end,
	},
	-- {
	-- 	"pmizio/typescript-tools.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	-- 	opts = {},
	-- },
}
