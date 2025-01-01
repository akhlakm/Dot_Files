return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			require("neo-tree").setup({
				rocks = {
					enabled = false,
				},
				window = {
					position = "left",
					width = 30,
				},
				sources = {
					"filesystem",
				},
				filesystem = {
					filtered_items = {
						visible = true,
						hide_gitignored = false,
						hide_hidden = false,
						hide_dotfiles = false,
					},
					follow_current_file = {
						enabled = true,
					},
					hijack_netrw_behavior = "open_default",
				},
			})
		end,
	},
}
