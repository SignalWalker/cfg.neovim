local glow_ok, _ = pcall(require, 'glow')
if glow_ok then
	vim.keymap.set('n', '<Leader>bp', '<cmd>Glow<cr>', { desc = "preview markdown file" })
end

vim.opt.wrap = true

vim.keymap.set('n', 'j', 'gj', { remap = false })
vim.keymap.set('n', 'k', 'gk', { remap = false })

vim.keymap.set('n', '<Up>', 'gk', { remap = false })
vim.keymap.set('n', '<Down>', 'gj', { remap = false })

vim.keymap.set('i', '<Up>', '<C-o>gk', { remap = false })
vim.keymap.set('i', '<Down>', '<C-o>gj', { remap = false })
