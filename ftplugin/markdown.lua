vim.opt.wrap = true
vim.opt.conceallevel = 2

vim.keymap.set("n", "j", "gj", { remap = false })
vim.keymap.set("n", "k", "gk", { remap = false })

vim.keymap.set("n", "<Up>", "gk", { remap = false })
vim.keymap.set("n", "<Down>", "gj", { remap = false })

vim.keymap.set("i", "<Up>", "<C-o>gk", { remap = false })
vim.keymap.set("i", "<Down>", "<C-o>gj", { remap = false })
