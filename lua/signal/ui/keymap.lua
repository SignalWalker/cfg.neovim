-- for key, dir in pairs({ h = "<Left>", j = "<Down>", k = "<Up>", l = "<Right>" }) do
-- 	vim.keymap.set("n", "<M-" .. key .. ">", "<C-w>" .. key, { desc = "move buffer focus " .. dir, silent = true })
-- 	vim.keymap.set("i", "<M-" .. key .. ">", dir, { desc = "move cursor " .. dir, silent = true })
-- end

vim.keymap.set("n", "<H-t>", "<cmd>tabnew<cr>", { desc = "open new tab", silent = true })
vim.keymap.set("n", "<H-h>", "<cmd>tabprevious<cr>", { desc = "move cursor to previous tab", silent = true })
vim.keymap.set("n", "<H-l>", "<cmd>tabnext<cr>", { desc = "move cursor to next tab", silent = true })

vim.keymap.set("n", "<C-w>t", "<cmd>tabnew<cr>", { desc = "open new tab", silent = true })
vim.keymap.set("n", "<C-M-h>", "<cmd>tabprevious<cr>", { desc = "switch to previous tab", silent = true })
vim.keymap.set("n", "<C-M-l>", "<cmd>tabnext<cr>", { desc = "switch to next tab", silent = true })

vim.keymap.set("n", "<Leader><C-x>", "<cmd>bdelete<cr>", { desc = "wipe buffer" })

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- extra keymaps set in plugin init & ftplugin files
