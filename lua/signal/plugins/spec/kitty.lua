return {
	{
		"knubie/vim-kitty-navigator",
		enabled = false,
		opts = {},
		-- build = "cp pass_keys.py get_layout.py ~/.config/kitty",
	},
	{
		"mikesmithgh/kitty-scrollback.nvim",
		enabled = false,
		version = "^4",
		lazy = true,
		cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
		event = { "User KittyScrollbackLaunch" },
		opts = {},
	},
}
