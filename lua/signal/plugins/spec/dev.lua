local trouble_toggle = function(mode)
	return function()
		require("trouble").toggle(mode)
	end
end

return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<Leader>xx", trouble_toggle(), desc = "trouble :: toggle" },
			{
				"<Leader>xw",
				trouble_toggle("workspace_diagnostics"),
				desc = "trouble :: toggle (workspace diagnostics)",
			},
			{
				"<Leader>xd",
				trouble_toggle("document_diagnostics"),
				desc = "trouble :: toggle (document diagnostics)",
			},
			{ "<Leader>xq", trouble_toggle("quickfix"), desc = "trouble :: toggle (quickfix)" },
			{ "<Leader>xl", trouble_toggle("loclist"), desc = "trouble :: toggle (quickfix)" },
		},
		opts = {},
	},
	{
		"folke/todo-comments.nvim",
		lazy = false,
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<Leader>xt", "<cmd>TodoTrouble<cr>", desc = "trouble :: toggle (todos)" },
			{ "<Leader>fpt", "<cmd>TodoTelescope<cr>", desc = "project :: list todos" },
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
		lazy = false,
		-- keys = {
		--  { '<Leader>cl', '<Plug>(comment_toggle_linewise)', desc = 'comment :: toggle line (linewise)' },
		--  { '<Leader>cb', '<Plug>(comment_toggle_blockwise)', desc = 'comment :: toggle line (blockwise)' },
		--  { '<Leader>cl', '<Plug>(comment_toggle_linewise_visual)', mode = 'x', desc = 'comment :: toggle linewise' },
		--  { '<Leader>cb', '<Plug>(comment_toggle_blockwise_visual)', mode = 'x', desc = 'comment :: toggle blockwise' },
		-- },
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
		enabled = false,
		branch = "v0.3",
		opts = {},
		config = function(_, opts)
			require("distant"):setup(opts)
		end,
	},
}
