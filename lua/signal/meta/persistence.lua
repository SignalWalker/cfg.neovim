vim.opt.backup = false
vim.opt.writebackup = true
vim.opt.undofile = true

-- ending one of these with // makes nvim name the files with the (escaped) full path to the original
-- putting these in cache because a) they're not permanent enough for elsewhere and b) i made cache optimized for small/fast writes
vim.opt.backupdir = { vim.fn.stdpath("cache") .. "/backup//" }
vim.opt.undodir = { vim.fn.stdpath("cache") .. "/undo//" }

vim.opt.updatetime = 300

vim.opt.sessionoptions = {
	"blank",
	"buffers",
	"curdir",
	"folds",
	"help",
	"tabpages",
	"winsize",
	"terminal",
}
