local glow_ok, _ = pcall(require, 'glow')
if glow_ok then
	vim.keymap.set('n', '<Leader>bp', '<cmd>Glow<cr>', { desc = "preview markdown file" })
end
