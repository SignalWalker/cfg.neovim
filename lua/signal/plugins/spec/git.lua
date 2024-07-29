local neogit_open = function(opts)
	return function()
		require("neogit").open(opts)
	end
end

return {
	{
		"sindrets/diffview.nvim",
		lazy = false,
		cmd = { "DiffViewOpen" },
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			keymaps = {},
		},
	},
	{
		"NeogitOrg/neogit",
		-- branch = "nightly", -- because we're using nvim v0.10
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<Leader>gs", neogit_open(), desc = "open git status" },
			{ "<Leader>gc", neogit_open({ "commit" }), desc = "git commit" },
		},
		opts = {
			graph_style = "unicode",
		},
	},
	{
		"FabijanZulj/blame.nvim",
		keys = {
			{ "<Leader>gb", "<cmd>BlameToggle<cr>", desc = "toggle git blame" },
		},
		opts = {
			date_format = "%Y-%m-%d",
			merge_consecutive = true,
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			trouble = true,
		},
	},
}
