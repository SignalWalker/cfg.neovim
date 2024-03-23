local lazy_dir = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- -> (is_bootstrapped, lazy)
local function ensure_lazy()
	-- check for system packer
	local p_ok, lazy = pcall(require, "lazy")
	local bootstrapped = false
	if not p_ok then
		-- no system lazy; install locally
		if not vim.loop.fs_stat(lazy_dir) then
			vim.fn.system({
				"git",
				"clone",
				"--filter=blob:none",
				"https://github.com/folke/lazy.nvim.git",
				"--branch=stable", -- latest stable release
				lazy_dir,
			})
		end
		bootstrapped = true
	end
	vim.opt.rtp:prepend(lazy_dir)
	if bootstrapped then
		lazy = require("lazy")
	end
	return bootstrapped, lazy
end

local _, lazy = ensure_lazy()

return lazy.setup("signal.plugins.spec", {
	diff = {
		cmd = "diffview.nvim",
	},
	checker = {
		enabled = true,
	},
})
