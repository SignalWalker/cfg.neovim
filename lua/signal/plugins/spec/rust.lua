return {
	{
		"saecki/crates.nvim",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		tag = "stable",
		event = { "BufRead Cargo.toml" },
		opts = {},
		init = function()
			vim.api.nvim_create_autocmd("BufRead", {
				group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
				pattern = "Cargo.toml",
				callback = function()
					local cmp = require("cmp")
					cmp.setup.buffer({
						sources = cmp.config.sources(
							{ { name = "crates" } },
							{ { name = "buffer" } },
							{ { name = "async_path" } }
						),
					})
				end,
			})
		end,
	},
}
