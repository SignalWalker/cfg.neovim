return {
	{
		"ms-jpq/chadtree",
		enabled = false,
		branch = "chad",
		build = "python3 -m chadtree deps",
		keys = {
			{ "<Leader>tt", "<cmd>CHADopen<cr>", desc = "filetree :: toggle" },
			{ "<Leader>tv", "<cmd>CHADopen --version-ctl<cr>", desc = "filetree :: open at vc root" },
		},
		opts = {
			xdg = true,
			keymap = {
				v_split = { "<C-v>" },
				h_split = { "<C-s>" },
				open_sys = { "<M-o>" },
			},
			theme = {
				text_color_set = "nerdtree_syntax_dark",
			},
		},
		config = function(_, opts)
			vim.api.nvim_set_var("chadtree_settings", opts)
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		enabled = false,
		-- lazy = false,
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim",
			"s1n7ax/nvim-window-picker",
		},
		keys = {
			{ "<Leader>tt", "<cmd>Neotree toggle reveal action=focus<cr>", desc = "filetree :: toggle" },
		},
		opts = {
			enable_cursor_hijack = true,
			use_popups_for_input = false,
			auto_clean_after_session_restore = true,
			filesystem = {
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
				use_libuv_file_watcher = true,
			},
			window = {
				mappings = {
					["<cr>"] = { "open_with_window_picker", config = { expand_nested_files = true } },
					["<C-v>"] = "vsplit_with_window_picker",
					["<C-s>"] = "split_with_window_picker",
				},
			},
		},
	},
	{
		"stevearc/oil.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{
				"-",
				function()
					require("oil").open()
				end,
				desc = "Open parent directory",
			},
			{
				"_",
				function()
					require("oil").open(vim.loop.cwd())
				end,
				desc = "Open current working directory",
			},
		},
		opts = {
			default_file_explorer = true,
			experimental_watch_for_changes = true,
			delete_to_trash = true,
			lsp_file_methods = {
				autosave_changes = true,
			},
			columns = {
				"icon",
				"permissions",
				"size",
				{ "mtime", format = "%Y-%m-%d %H:%M" },
			},
			constrain_cursor = "name",
			view_options = {
				natural_order = false,
				sort = {
					{ "type", "asc" },
					{ "name", "asc" },
				},
			},
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		enabled = false,
		lazy = false,
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"s1n7ax/nvim-window-picker",
		},
		keys = {
			{ "<Leader>tt", "<cmd>NvimTreeToggle<cr>", desc = "filetree :: toggle" },
			{ "<Leader>tf", "<cmd>NvimTreeFindFile<cr>", desc = "filetree :: find file" },
		},
		-- init = function()
		-- 	vim.g.loaded_netrw = 1
		-- 	vim.g.loaded_netrwPlugin = 1
		-- end,
		opts = function(_, _)
			return {
				disable_netrw = true,
				hijack_netrw = false,

				sync_root_with_cwd = true,
				respect_buf_cwd = true,
				reload_on_bufenter = true,

				hijack_cursor = true,
				select_prompts = true,

				sort = {
					sorter = "extension",
					folders_first = true,
				},

				view = {
					preserve_window_proportions = true,
					signcolumn = "yes",
					width = {
						min = 16,
						max = 32,
						padding = 1,
					},
				},

				renderer = {
					group_empty = true,
					full_name = true,
					root_folder_label = false,
					special_files = {
						"Cargo.toml",
						"Makefile",
						"README.md",
						"readme.md",
						"flake.nix",
					},
					highlight_git = "icon",
					highlight_diagnostics = "icon",
					highlight_opened_files = "none",
					highlight_modified = "name",
					indent_markers = {
						enable = true,
					},
					icons = {
						web_devicons = {
							folder = {
								enable = true,
							},
						},
					},
				},

				hijack_directories = {
					enable = false, -- defer to oil.nvim
					auto_open = false,
				},

				update_focused_file = {
					enable = true,
					update_root = false,
				},

				git = {
					enable = true,
					show_on_open_dirs = false,
				},

				diagnostics = {
					enable = true,
					show_on_dirs = true,
					show_on_open_dirs = false,
					severity = {
						min = vim.diagnostic.severity.WARN,
					},
				},

				modified = {
					enable = true,
					show_on_dirs = true,
					show_on_open_dirs = false,
				},

				filters = {
					git_ignored = true,
					dotfiles = true,
				},

				filesystem_watchers = {
					enable = true,
				},

				actions = {
					use_system_clipboard = true,
					change_dir = {
						enable = true,
						restrict_above_cwd = true,
					},
					open_file = {
						window_picker = {
							enable = true,
							picker = require("window-picker").pick_window,
						},
					},
				},

				trash = {
					cmd = "trash",
				},

				tab = {
					sync = {
						open = false,
						close = false,
					},
				},
			}
		end,
	},
	{
		"antosha417/nvim-lsp-file-operations",
		enabled = false,
		event = "LspAttach",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
			-- "nvim-neo-tree/neo-tree.nvim",
		},
		opts = {},
	},
}
