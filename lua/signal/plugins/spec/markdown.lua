local notes_dir = vim.env.XDG_NOTES_DIR or (vim.env.HOME .. "/notes")
local notes_pattern = notes_dir .. "/**.md"

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
		lazy = not vim.g.__force_obsidian,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
			-- "hrsh7th/nvim-cmp",
			-- "ms-jpq/coq_nvim",
		},
		event = {
			"BufReadPre " .. notes_pattern,
			"BufNewFile " .. notes_pattern,
		},
		cmd = {
			"ObsidianYesterday",
			"ObsidianToday",
		},
		opts = {
			workspaces = {
				{
					name = "Notes",
					path = notes_dir,
				},
			},
			daily_notes = {
				folder = "daily",
				date_format = "%Y-%m-%d",
				alias_format = nil,
				template = "daily.md",
				default_tags = {},
			},
			templates = {
				subdir = "template",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
				substitutions = {
					["date:MMMM D, YYYY"] = function()
						return os.date("%B %d, %y")
					end,
				},
			},
			completion = {
				nvim_cmp = false,
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
			follow_url_func = function(url)
				vim.fn.jobstart({ "app2unit-open", url })
				vim.notify(
					"Opened " .. url .. " in external program",
					vim.log.levels.INFO,
					{ title = "Obsidian", icon = "" }
				)
			end,
			callbacks = {
				post_set_workspace = function(client, workspace)
					vim.notify(
						"Entered workspace: " .. workspace.path.filename,
						vim.log.levels.INFO,
						{ title = "Obsidian", icon = "" }
					)
				end,
				enter_note = function(_client, note)
					vim.wo.conceallevel = 2
					local bufnr = note.bufnr
					if bufnr == nil then
						vim.notify("enter_note called without bufnr", vim.log.levels.WARN, { title = "Obsidian" })
						return
					end
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
			},
		},
	},
}
