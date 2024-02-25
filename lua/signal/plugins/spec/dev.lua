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
			{ "<Leader>xt", trouble_toggle(), desc = "trouble :: toggle" },
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
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"direnv/direnv.vim",
		init = function()
			vim.g.direnv_silent_load = 0
		end,
		config = function(plugin, opts)
			-- vim.api.nvim_create_autocmd({ "DirenvLoaded" }, {
			-- 	group = vim.api.nvim_create_augroup("NotifyDirenv", { clear = true }),
			-- 	pattern = "Cargo.toml",
			-- 	callback = function(args)
			-- 		print("Loaded direnv for " .. args["file"])
			-- 	end,
			-- })
		end,
	},
	{
		"sindrets/diffview.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
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
}
