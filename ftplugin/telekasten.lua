local telekasten_ok, _ = pcall(require, 'telekasten')
if telekasten_ok then
	vim.keymap.set('n', '<Leader>zg', '<cmd>Telekasten follow_link<cr>', { desc = "telekasten :: follow link", noremap = true, silent = true })
	vim.keymap.set('n', '<Leader>zt', '<cmd>Telekasten toggle_todo<cr>', { desc = "telekasten :: toggle todo", noremap = true, silent = true })
	vim.keymap.set('n', '<Leader>zi', '<cmd>Telekasten preview_img<cr>', { desc = "telekasten :: preview image", noremap = true, silent = true })
	vim.keymap.set('n', '<Leader>zr', '<cmd>Telekasten rename_note<cr>', { desc = "telekasten :: rename note & update links", noremap = true, silent = true })

	vim.keymap.set('n', '<Leader>zfl', '<cmd>Telekasten show_backlinks<cr>', { desc = "telekasten :: show backlinks", noremap = true, silent = true })
	vim.keymap.set('n', '<Leader>zff', '<cmd>Telekasten find_friends<cr>', { desc = "telekasten :: list notes linking to note linked under cursor", noremap = true, silent = true })

	vim.keymap.set('n', '<Leader>zpl', '<cmd>Telekasten insert_link<cr>', { desc = "telekasten :: insert link", noremap = true, silent = true })
	vim.keymap.set('n', '<Leader>zpi', '<cmd>Telekasten paste_img_and_link<cr>', { desc = "telekasten :: paste image to file and insert link", noremap = true, silent = true })

	vim.keymap.set('n', '<Leader>zyl', '<cmd>Telekasten yank_notelink<cr>', { desc = "telekasten :: yank link to current note", noremap = true, silent = true })
end
