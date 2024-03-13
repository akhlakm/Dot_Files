-- NVIM Configurations

-- Set <space> as the leader key
-- See `:help mapleader`
-- Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

require("options")

require("keymaps")

require("lazy-plugins")

require("terminal")

-- Colorscheme
vim.cmd("colorscheme ayu")

-- Open neotree on startup
vim.cmd("Neotree toggle")

-- replace tabs with spaces
vim.opt.expandtab = true -- Set this to override paste, which resets expandtab
