local in_kitty = vim.env.TERM == "xterm-kitty"

return {
	{
		"knubie/vim-kitty-navigator",
		enabled = false,
		cond = in_kitty,
		opts = {},
		-- build = "cp pass_keys.py get_layout.py ~/.config/kitty",
	},
	{
		"mikesmithgh/kitty-scrollback.nvim",
		version = "^4",
		enabled = false,
		cond = in_kitty,
		lazy = true,
		cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
		event = { "User KittyScrollbackLaunch" },
		opts = {},
	},
}
