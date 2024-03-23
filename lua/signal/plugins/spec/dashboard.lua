return {
	{
		"nvimdev/dashboard-nvim",
		enabled = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "VimEnter",
		opts = function(plugin, opts)
			local tlib = require("signal.lib.theme")
			local header, h_width = tlib.split_header(tlib.choose_header_file())
			return {
				theme = "doom",
				config = {
					header = header,
					-- week_header = {
					-- 	enable = true,
					-- },
				},
			}
		end,
	},
	{
		"echasnovski/mini.starter",
		enabled = false,
		-- event = { 'VimEnter' },
		version = false,
		opts = function(plugin, opts)
			local tlib = require("signal.lib.theme")
			local header, h_width = tlib.split_header(tlib.choose_header_file())
			return {
				header = table.concat(header, "\n"),
			}
		end,
	},
	{
		"goolord/alpha-nvim",
		event = { "VimEnter" },
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nvim-lua/plenary.nvim",
		},
		opts = function()
			local dashboard = require("alpha.themes.dashboard")
			local tlib = require("signal.lib.theme")

			local header, _ = tlib.split_header(tlib.choose_header_file())
			dashboard.section.header.val = header
			dashboard.section.header.opts.hl = "AlphaHeader"

			dashboard.opts.leader = ";"
			dashboard.section.buttons.val = {
				-- stylua: ignore
				dashboard.button('s', "勒> Restore Session", function() require('persistence').load() end),
				dashboard.button("l", "鈴> Lazy", "<cmd>Lazy<CR>"),
				dashboard.button("n", "N> Edit Neovim Config", function()
					local cfg_dir = vim.env.XDG_CONFIG_HOME .. "/nvim"
					vim.cmd.tcd(cfg_dir)
					vim.cmd.edit(cfg_dir .. "/init.lua")
				end),
				dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
			}
			for _, button in ipairs(dashboard.section.buttons.val) do
				button.opts.hl = "AlphaButtons"
				button.opts.hl_shortcut = "AlphaShortcut"
			end
			dashboard.section.buttons.hl = "AlphaButtons"

			dashboard.section.footer.opts.hl = "Type"

			return dashboard
		end,
		config = function(_, dashboard)
			if vim.o.filetype == "lazy" then
				vim.cmd.close()
				vim.api.nvim_create_autocmd("User", {
					pattern = "AlphaReady",
					callback = function()
						require("lazy").show()
					end,
				})
			end

			require("alpha").setup(dashboard.opts)

			vim.api.nvim_create_autocmd({ "User" }, {
				group = vim.api.nvim_create_augroup("UpdateDashboard", { clear = true }),
				pattern = "LazyVimStarted",
				callback = function(_)
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					local stats_str = stats.loaded .. "/" .. stats.count .. " Plugins Loaded (" .. ms .. " ms)"
					dashboard.section.footer.val = stats_str
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},
}
