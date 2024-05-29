-- for key, dir in pairs({ h = "<Left>", j = "<Down>", k = "<Up>", l = "<Right>" }) do
-- 	vim.keymap.set("n", "<M-" .. key .. ">", "<C-w>" .. key, { desc = "move buffer focus " .. dir, silent = true })
-- 	vim.keymap.set("i", "<M-" .. key .. ">", dir, { desc = "move cursor " .. dir, silent = true })
-- end

vim.opt.tildeop = true

vim.keymap.set("n", "<D-t>", "<cmd>tabnew<cr>", { desc = "Open new tab", silent = true })
vim.keymap.set("n", "<D-h>", "<cmd>tabprevious<cr>", { desc = "Switch to previous tab", silent = true })
vim.keymap.set("n", "<D-l>", "<cmd>tabnext<cr>", { desc = "Switch to next tab", silent = true })

vim.keymap.set("n", "<C-w>t", "<cmd>tabnew<cr>", { desc = "Open new tab", silent = true })
vim.keymap.set("n", "<C-M-h>", "<cmd>tabprevious<cr>", { desc = "Switch to previous tab", silent = true })
vim.keymap.set("n", "<C-M-l>", "<cmd>tabnext<cr>", { desc = "Switch to next tab", silent = true })

vim.keymap.set(
	"n",
	"<C-w><C-q>",
	"<cmd>bdelete<cr>",
	{ desc = "Unload buffer and delete it from bufferlist", silent = true }
)

-- extra keymaps set in plugin init & ftplugin files
