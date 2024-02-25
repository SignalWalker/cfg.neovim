vim.opt.runtimepath:append(vim.fn.stdpath("cache")) -- TODO :: Why?

-- local i_ok, impatient = pcall(require, 'impatient')
-- local p_ok, _ = pcall(require, 'packer_compiled')
-- if i_ok and p_ok then impatient.enable_profile() end

vim.opt.backup = false
vim.opt.writebackup = true
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup,.,/tmp"
vim.opt.backupskip:append("*~")

vim.opt.updatetime = 300
vim.opt.timeoutlen = 500

vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

require("signal.plugins")
require("signal.ui")
require("signal.theme")
