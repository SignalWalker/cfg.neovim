vim.opt.linespace = 0

vim.opt.guifont = 'Iosevka:h9'

vim.keymap.set('n', '<Leader>vct', function()
	local scheme = vim.api.nvim_exec("colorscheme", true)
	if vim.o.background == "light" then
		vim.o.background = "dark"
		vim.g.everforest_transparent_background = 1
	else
		vim.o.background = "light"
		vim.g.everforest_transparent_background = 0
	end
	if scheme == "everforest" then
		vim.cmd.colorscheme(scheme)
	end
end, { desc = "switch between light and dark theme" })
