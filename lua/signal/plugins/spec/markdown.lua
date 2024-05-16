return {
	{
		"ellisonleao/glow.nvim",
		cmd = "Glow",
		keys = {
			{ "<Leader>bp", "<cmd>Glow<cr>", ft = "markdown", desc = "buffer :: preview (glow)" },
		},
		opts = {},
	},
	{
		"epwalsh/obsidian.nvim",
		version = "^3",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
			"hrsh7th/nvim-cmp",
			-- "ms-jpq/coq_nvim",
		},
		event = {
			"BufReadPre /home/ash/notes/**.md",
			"BufNewFile /home/ash/notes/**.md",
		},
		cmd = {
			"ObsidianYesterday",
			"ObsidianToday",
		},
		opts = {
			workspaces = {
				{
					name = "Notes",
					path = "~/notes",
				},
			},
			daily_notes = {
				folder = "daily",
				date_format = "%Y-%m-%d",
				template = "daily.md",
			},
			templates = {
				subdir = "template",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
			},
			completion = {
				nvim_cmp = true,
			},
			mappings = {},
			new_notes_location = "current_dir",
			picker = {
				name = "telescope.nvim",
			},
			ui = {
				enable = true,
			},
			attachments = {
				img_folder = "data/img",
			},
		},
		init = function()
			vim.api.nvim_create_autocmd({ "BufReadPre" }, {
				group = vim.api.nvim_create_augroup("obsidian_setup_extra", { clear = true }),
				pattern = "/home/ash/notes/**.md",
				callback = function(args)
					vim.wo.conceallevel = 2
					local bufnr = args["buf"]
					local kopts_base = { noremap = true, silent = true, buffer = bufnr }
					local kopts = function(desc)
						if desc == nil then
							return kopts_base
						else
							return {
								noremap = kopts_base["noremap"],
								silent = kopts_base["silent"],
								buffer = kopts_base["buffer"],
								desc = desc,
							}
						end
					end
					local ob = require("obsidian")
					vim.keymap.set("n", "<Leader>oa", "<cmd>ObsidianOpen<cr>", kopts("Obsidian :: Open in app"))
					vim.keymap.set("n", "gf", function()
						if ob.util.cursor_on_markdown_link() then
							return "<cmd>ObsidianFollowLink<cr>"
						else
							return "gf"
						end
					end, {
						desc = "Go to file under cursor (obsidian)",
						buffer = bufnr,
						expr = true,
						noremap = false,
					})
					vim.keymap.set("n", "<Leader>ob", "<cmd>ObsidianBacklinks<cr>", kopts("Obsidian :: List backlinks"))
					vim.keymap.set("n", "<Leader>odt", "<cmd>ObsidianToday<cr>", kopts("Obsidian :: Open today's note"))
					vim.keymap.set(
						"n",
						"<Leader>ody",
						"<cmd>ObsidianYesterday<cr>",
						kopts("Obsidian :: Open yesterday's note")
					)
					vim.keymap.set("n", "<Leader>ot", "<cmd>ObsidianTemplate<cr>", kopts("Obsidian :: Open template"))
					vim.keymap.set("n", "<Leader>og", "<cmd>ObsidianSearch<cr>", kopts("Obsidian :: Search"))
					vim.keymap.set("n", "<Leader>oll", "<cmd>ObsidianLink<cr>", kopts("Obsidian :: Link to note"))
					vim.keymap.set(
						"n",
						"<Leader>ole",
						"<cmd>ObsidianLinkNew<cr>",
						kopts("Obsidian :: Link to new note")
					)
				end,
			})
		end,
	},
}
