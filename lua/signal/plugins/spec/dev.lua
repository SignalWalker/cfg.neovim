local function toggle_trouble(mode, opts)
	local desc = {
		mode = mode,
		focus = false,
		-- preview = {
		-- 	type = "split",
		-- 	relative = "win",
		-- 	position = "right",
		-- 	size = 0.3,
		-- },
	}
	if opts ~= nil then
		for k, v in pairs(opts) do
			desc[k] = v
		end
	end
	return function()
		require("trouble").toggle(desc)
	end
end

return {
	{
		"folke/trouble.nvim",
		branch = "main",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = {
			"Trouble",
		},
		keys = {
			{ "<Leader>xx", toggle_trouble("cascade"), desc = "toggle diagnostics" },
			{
				"<Leader>xb",
				toggle_trouble("diagnostics", { filter = { buf = 0 } }),
				desc = "toggle diagnostics (buffer)",
			},
			{ "<Leader>xQ", toggle_trouble("qflist"), desc = "toggle quickfix list" },
			{ "<Leader>xL", toggle_trouble("loclist"), desc = "toggle loclist" },
			{ "<Leader>xs", toggle_trouble("symbols", { preview = { type = "main" } }), desc = "toggle symbols" },
		},
		specs = {
			"folke/snacks.nvim",
			opts = function(_, opts)
				return vim.tbl_deep_extend("force", opts or {}, {
					picker = {
						actions = require("trouble.sources.snacks").actions,
						win = {
							input = {
								keys = {
									["<c-t>"] = {
										"trouble_open",
										mode = { "n", "i" },
									},
								},
							},
						},
					},
				})
			end,
		},
		opts = {
			preview = {
				type = "float",
				relative = "editor",
				border = "rounded",
				title = "Preview",
				title_pos = "center",
				position = { 0, -2 },
				size = { width = 0.3, height = 0.3 },
				zindex = 200,
				scratch = true,
			},
			modes = {
				cascade = {
					mode = "diagnostics",
					filter = function(items)
						local severity = vim.diagnostic.severity.HINT
						for _, item in ipairs(items) do
							severity = math.min(severity, item.severity)
						end
						return vim.tbl_filter(function(item)
							return item.severity == severity
						end, items)
					end,
				},
			},
		},
	},
	{
		"folke/todo-comments.nvim",
		event = { "LspAttach" },
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"<Leader>ftc",
				function()
					Snacks.picker.todo_comments()
				end,
				desc = "find any note comment",
			},
			{
				"<Leader>ftt",
				function()
					Snacks.picker.todo_comments({ keywords = { "FIX", "TODO" } })
				end,
				desc = "find todo comments",
			},
			{
				"]o",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "next todo",
			},
			{
				"[o",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "previous todo",
			},
		},
		opts = {
			keywords = {
				FIX = { icon = "" },
				TODO = { icon = "", alt = { "todo", "unimplemented" } },
				HACK = { icon = "" },
				WARN = { icon = "" },
				PERF = { icon = "" },
				NOTE = { icon = "" },
				IDEA = {
					icon = "",
					color = "info",
				},
				TEST = { icon = "⏲" },
			},
			highlight = {
				pattern = {
					[[.*<(KEYWORDS)\s*:]],
					[[.*<(KEYWORDS)\s*!\(]],
				},
				comments_only = false,
			},
			search = {
				pattern = [[\b(KEYWORDS)\s*(:|!\()]],
			},
		},
	},
	{
		"NMAC427/guess-indent.nvim",
		opts = {},
	},
	{
		"direnv/direnv.vim",
		-- lazy = true,
		-- event = { "VeryLazy" },
		-- opts = {},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<Leader>bf",
				function()
					require("conform").format({ async = false, lsp_fallback = true })
				end,
				desc = "format buffer",
			},
		},
		opts = {
			default_format_opts = {
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				nix = { "nixfmt", lsp_format = "fallback" },
				css = { "stylelint" },
				lua = { "stylua" },
				rust = { "rustfmt", lsp_format = "fallback" },
				toml = { "taplo" },
				c_sharp = { "csharpier", lsp_format = "fallback" },
				["_"] = { "trim_whitespace" },
			},
			format_on_save = { timeout_ms = 500, lsp_fallback = true },
		},
		init = function()
			vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
		end,
	},
	{
		"chipsenkbeil/distant.nvim",
		enabled = false,
		branch = "v0.3",
		opts = {},
		config = function(_, opts)
			require("distant"):setup(opts)
		end,
	},
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"nvim-pack/nvim-spectre",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		build = "/usr/bin/env bash ./build.sh",
		cmd = { "Spectre" },
		keys = {
			{
				"<Leader>fpr",
				function()
					require("spectre").toggle()
				end,
				desc = "Spectre :: toggle",
			},
			{
				"<Leader>sw",
				function()
					require("spectre").open_visual({ select_word = true })
				end,
				desc = "Spectre :: Search current word",
			},
			{
				"<Leader>sw",
				mode = { "v" },
				function()
					require("spectre").open_visual()
				end,
				desc = "Spectre :: Search current word",
			},
		},
		opts = {
			default = {
				replace = {
					cmd = "oxi",
				},
			},
		},
	},
	{
		"Olical/conjure",
		dependencies = { "PaterJason/cmp-conjure" },
		lazy = true,
		ft = { "clojure", "fennel", "guile" },
	},
}
