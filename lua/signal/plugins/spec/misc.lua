return {
	{
		"Eandrju/cellular-automaton.nvim",
		dependencies = {
			-- "nvim-treesitter/nvim-treesitter",
		},
		cmd = { "CellularAutomaton" },
		keys = {
			{ "<Leader>bcg", "<cmd>CellularAutomaton make_it_rain<cr>", desc = "enable gravity" },
			{ "<Leader>bcl", "<cmd>CellularAutomaton game_of_life<cr>", desc = "enable life" },
		},
	},
	{
		"rktjmp/playtime.nvim",
		cmd = { "Playtime" },
		opts = {},
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {},
		init = function()
			local Snacks = require("snacks")
			_G.dd = function(...)
				Snacks.debug.inspect(...)
			end
			_G.bt = function()
				Snacks.debug.backtrace()
			end
			vim.print = _G.dd
		end,
	},
}
