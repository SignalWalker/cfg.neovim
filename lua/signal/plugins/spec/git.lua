local neogit_open = function(opts)
	return function()
		require("neogit").open(opts)
	end
end

return {
	{
		"sindrets/diffview.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			keymaps = {},
		},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<Leader>gs", neogit_open(), desc = "git :: status" },
			{ "<Leader>gc", neogit_open({ "commit" }), desc = "git :: commit" },
		},
		opts = {},
	},
}
