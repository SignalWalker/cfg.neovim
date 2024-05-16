vim.opt.runtimepath:append(vim.fn.stdpath("cache")) -- TODO :: Why?

vim.opt.timeoutlen = 500

vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

require("signal.meta")
require("signal.plugins")
require("signal.ui")
require("signal.theme")
