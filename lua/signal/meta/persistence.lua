vim.opt.backup = false
vim.opt.writebackup = true
vim.opt.backupdir = { "/tmp", vim.fn.stdpath("state") .. "/backup//" }

vim.opt.undodir = { vim.fn.stdpath("state") .. "/undo//" }
vim.opt.undofile = true

vim.opt.updatetime = 300
