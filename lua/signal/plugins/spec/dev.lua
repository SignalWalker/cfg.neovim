local function toggle_trouble(mode, opts)
	local desc = {
		mode = mode,
		focus = false,
		preview = {
			type = "split",
			relative = "win",
			position = "right",
			size = 0.3,
		},
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
		branch = "dev",
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
		opts = {
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
			{ "<Leader>xt", "<cmd>TodoTrouble<cr>", desc = "toggle todo list" },
			{ "<Leader>fpt", "<cmd>TodoTelescope<cr>", desc = "view todo list in telescope" },
		},
		opts = {
			keywords = {
				TODO = { alt = { "todo!", "unimplemented!" } },
			},
			highlight = {
				pattern = {
					[[.*<(KEYWORDS)\s*:]],
					[[.*<(KEYWORDS)\s*!\(]],
				},
				comments_only = false,
			},
			search = {
				pattern = [[\b(KEYWORDS)(:|!\()]],
			},
		},
	},
	{
		"NMAC427/guess-indent.nvim",
		opts = {},
	},
	{
		"direnv/direnv.vim",
		init = function()
			vim.g.direnv_silent_load = 1
		end,
		config = function(_, _)
			-- vim.api.nvim_create_autocmd({ "User" }, {
			-- 	group = vim.api.nvim_create_augroup("NotifyDirenv", { clear = true }),
			-- 	pattern = "DirenvLoaded",
			-- 	callback = function(args)
			-- 		print("Direnv loaded for " .. vim.loop.cwd())
			-- 	end,
			-- })
		end,
	},
	{
		"numToStr/Comment.nvim",
		enabled = false, -- superseded by built in functionality in neovim v0.10
		lazy = false,
		opts = {
			mappings = {
				basic = true,
				extra = false,
			},
		},
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
				desc = "buffer :: format",
			},
		},
		opts = {
			formatters_by_ft = {
				nix = { "alejandra" },
				lua = { "stylua" },
				rust = {}, -- fallback to lsp
				toml = { "taplo" },
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
		branch = "v0.3",
		opts = {},
		config = function(_, opts)
			require("distant"):setup(opts)
		end,
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
}
