return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			-- "saghen/blink.lib",
			"rafamadriz/friendly-snippets",
		},
		build = "nix run --accept-flake-config .#build-plugin",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = { preset = "super-tab" },
			completion = {
				menu = { border = "single" },
				documentation = { window = { border = "single" } },
			},
			signature = {
				enabled = true,
				trigger = {
					enabled = true,
				},
				window = {
					show_documentation = true,
					border = "single",
				},
			},
			sources = {
				providers = {
					path = {
						opts = {
							get_cwd = function(_)
								return vim.fn.getcwd()
							end,
						},
					},
				},
			},
		},
	},
}
