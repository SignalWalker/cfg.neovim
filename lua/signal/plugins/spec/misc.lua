return {
	{
		"Eandrju/cellular-automaton.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		cmd = { "CellularAutomaton" },
		keys = {
			{ "<Leader>bcr", "<cmd>CellularAutomaton make_it_rain<cr>", desc = "enable gravity" },
			{ "<Leader>bcl", "<cmd>CellularAutomaton game_of_life<cr>", desc = "enable life" },
		},
	},
	{
		"rktjmp/playtime.nvim",
		cmd = { "Playtime" },
		opts = {},
	},
}
