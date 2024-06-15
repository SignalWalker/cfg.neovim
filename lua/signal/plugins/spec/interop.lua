return {
	{
		"glacambre/firenvim",
		-- Lazy load firenvim
		-- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
		lazy = not vim.g.started_by_firenvim,
		build = function()
			vim.fn["firenvim#install"](0)
		end,
		init = function()
			vim.g.firenvim_config = {
				localSettings = {
					[".*"] = {
						takeover = "never",
						cmdline = "none",
					},
				},
			}
			if vim.g.started_by_firenvim == true then
				vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
					callback = function(e)
						if vim.g.firenvim_timer_started == true then
							return
						end
						vim.g.firenvim_timer_started = true
						vim.fn.timer_start(200, function()
							vim.g.firenvim_timer_started = false
							vim.cmd.write()
						end)
					end,
				})
			end
		end,
	},
}
