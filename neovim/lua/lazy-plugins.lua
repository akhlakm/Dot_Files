-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins, you can run
--    :Lazy update
--
require("lazy").setup({
	-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

	-- Highlight other instances of a word under cursor.
	"RRethy/vim-illuminate",

	-- NOTE: Plugins can also be added by using a table,
	-- with the first argument being the link and the following
	-- keys can be used to configure plugin behavior/loading/etc.
	--
	-- Use `opts = {}` to force a plugin to be loaded.
	--
	--  This is equivalent to:
	--    require('Comment').setup({})

	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },

	-- Docstring generator for function.
	{
		"danymat/neogen",
		config = true,
		-- Uncomment next line if you want to follow only stable versions
		version = "*",
	},

	-- modular approach: using `require 'path/name'` will
	-- include a plugin definition from file lua/path/name.lua

	require("plugins.neotree"),

	require("plugins.neogit"),

	require("plugins.gitsigns"),

	require("plugins.which-key"),

	require("plugins.telescope"),

	require("plugins.lspconfig"),

	require("plugins.conform"),

	require("plugins.cmp"),

	require("plugins.tokyonight"),

	require("plugins.todo-comments"),

	require("plugins.mini"),

	require("plugins.treesitter"),

	require("plugins.markdown"),

	require("plugins.ayu"),

	require("plugins.noice"),

	require("plugins.lualine"),

	-- require("plugins.quarto"),

	-- require 'plugins.debug',
	require("plugins.indent_line"),

	require("plugins.iron"),

	-- Load the local sphinx plugin
	{
		dir = "sphinx",
		dev = true,
		config = function()
			require("sphinx").setup({
				test = "hello",
			})
		end,
	},

	-- Load a local plugin.
	{
		dir = "nota",
		name = "nota",
		dev = true,
		config = function()
			require("nota").setup({
				global_path = "nota/notes/",
				scratch_path = "nota/scratch/",
				local_path = "project-notes/",
				vertical_split = true,
			})
		end,
	},
}, {
	ui = {
		-- If you have a Nerd Font, set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
