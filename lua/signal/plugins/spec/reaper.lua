return {
	{
		"madskjeldgaard/reaper-nvim",
		lazy = true,
		dependencies = {
			"davidgranstrom/osc.nvim",
		},
		ft = { "supercollider", "csound" },
		init = function()
			vim.g.reaper_fuzzy_command = "fzf"
			vim.g.reaper_target_port = 48401
			vim.g.reaper_target_ip = "127.0.0.1"
			vim.g.reaper_browser_command = vim.env.BROWSER
		end,
	},
}
