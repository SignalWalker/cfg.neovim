vim.opt.runtimepath:append(vim.fn.stdpath("cache")) -- TODO :: Why?

vim.opt.timeoutlen = 500

vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- math.randomseed() -- TODO :: Why?

vim.g.theme_enable_terminal_effects = (vim.env.TERM == "xterm-kitty") -- and (vim.fn.has("gui_running") == 1)

require("signal.meta.projects")
require("signal.meta.persistence")
require("signal.meta.filetypes")
