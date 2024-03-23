local tokyonight_opts = {
	style = "storm",
	light_style = "day",
	sidebars = { "qf", "help", "NvimTree", "CHADTree" },
	transparent = true,
}

local swap_tokyonight = function()
	local style = tokyonight_opts.style

	if vim.o.background == "light" then
		vim.o.background = "dark"
		style = tokyonight_opts.style
	else
		vim.o.background = "light"
		style = tokyonight_opts.light_style
	end

	local style_conf = vim.env.XDG_CONFIG_HOME .. "/kitty/themes/tokyonight_" .. style .. ".conf"
	local kitty_cmd = "kitty @ set-colors " .. style_conf
	vim.fn.system(kitty_cmd)
end

local refresh_tokyonight = function(transparency)
	local opts = vim.deepcopy(tokyonight_opts)
	opts.transparency = transparency
	require("tokyonight").setup(opts)
	vim.cmd([[colorscheme tokyonight]])
end

return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = tokyonight_opts,
		keys = {
			{ "<Leader>vct", swap_tokyonight, desc = "toggle light/dark theme (tokyonight)" },
		},
		config = function(_, opts)
			local tk = require("tokyonight")
			tk.setup(opts)
		end,
	},
	{
		"folke/drop.nvim",
		enabled = false, -- FIX :: https://github.com/folke/drop.nvim/issues/15
		event = "VimEnter",
		opts = {},
	},
	{
		"stevearc/dressing.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			input = {
				enabled = true,
			},
			select = {
				enabled = true,
			},
		},
	},
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
			"nvim-telescope/telescope.nvim",
		},
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = false,
				inc_rename = true,
				lsp_doc_border = true,
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
			},
		},
		keys = {
			{ "<Leader>fvm", "<cmd>Noice telescope<cr>", desc = "telescope :: message history" },
			{ "<Leader>vns", "<cmd>Noice stats<cr>", desc = "noice :: stats" },
		},
		config = function(_, opts)
			local noice = require("noice")
			noice.setup(opts)

			local ts = require("telescope")
			ts.load_extension("noice")
		end,
	},
	{
		"3rd/image.nvim",
		lazy = true,
		opts = {
			backend = "kitty",
		},
	},
	{
		"giusgad/pets.nvim",
		lazy = true,
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"giusgad/hologram.nvim",
				opts = {
					auto_display = false,
				},
			},
		},
		keys = {
			{
				"<Leader>vpsd",
				function()
					local colors = { "brown", "black", "gray", "beige" }
					local color = colors[math.random(#colors)]
					local name = vim.loop.random(8, nil, nil)
					vim.cmd("PetsNewCustom dog " .. color .. " " .. name)
				end,
				desc = "summon dog",
			},
		},
		opts = {
			row = 5,
			col = 0,
			default_pet = "dog", -- cats not supported :(
			default_style = "gray",
			popup = {
				width = "100%",
				avoid_statusline = true,
			},
		},
	},
}
