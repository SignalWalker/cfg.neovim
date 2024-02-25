return {
	{
		"ms-jpq/chadtree",
		enabled = false,
		branch = "chad",
		build = "python3 -m chadtree deps",
		opts = {
			xdg = true,
			keymap = {
				v_split = { "<C-v>" },
				h_split = { "<C-s>" },
				open_sys = { "<M-o>" },
			},
		},
		config = function(plugin, opts)
			vim.api.nvim_set_var("chadtree_settings", opts)
			vim.keymap.set("n", "<Leader>tt", "<cmd>CHADopen<cr>", { desc = "open filetree" })
			vim.keymap.set("n", "<Leader>tv", "<cmd>CHADopen --version-ctl<cr>", { desc = "open filetree at vc root" })
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
		keys = {
			{ "<Leader>tt", "<cmd>Neotree toggle reveal action=focus<cr>", desc = "filetree :: toggle" },
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		-- enabled = false,
		lazy = false,
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<Leader>tt", "<cmd>NvimTreeToggle<cr>", desc = "filetree :: toggle" },
			{ "<Leader>tf", "<cmd>NvimTreeFindFile<cr>", desc = "filetree :: find file" },
		},
		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		opts = {
			disable_netrw = true,
			hijack_netrw = true,

			sort_by = "extension",

			sync_root_with_cwd = true,
			respect_buf_cwd = true,

			hijack_cursor = true,

			reload_on_bufenter = true,

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
				highlight_opened_files = "name",
				indent_markers = {
					enable = true,
				},
				icons = {
					webdev_colors = true,
				},
			},
			filters = {
				dotfiles = true,
			},
			filesystem_watchers = {
				enable = true,
			},
			update_focused_file = {
				enable = true,
			},
			git = {
				enable = true,
				show_on_open_dirs = false,
			},
			diagnostics = {
				show_on_dirs = true,
				show_on_open_dirs = false,
			},
			tab = {
				sync = {
					open = true,
					close = true,
				},
			},
		},
	},
	{
		"antosha417/nvim-lsp-file-operations",
		event = "LspAttach",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
			-- "nvim-neo-tree/neo-tree.nvim",
		},
		opts = {},
	},
}
