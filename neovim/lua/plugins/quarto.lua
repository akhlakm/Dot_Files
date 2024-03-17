return {
	{
		"quarto-dev/quarto-nvim",
		opts = {
			lspFeatures = {
				languages = { "python", "bash", "html", "lua" },
			},
		},
		ft = "quarto",
		keys = {
			{ "<leader>qa", ":QuartoActivate<cr>", desc = "quarto activate" },
			{ "<leader>qp", ":lua require'quarto'.quartoPreview()<cr>", desc = "quarto preview" },
			{ "<leader>qq", ":lua require'quarto'.quartoClosePreview()<cr>", desc = "quarto close" },
			{ "<leader>qh", ":QuartoHelp ", desc = "quarto help" },
			{ "<leader>qe", ":lua require'otter'.export()<cr>", desc = "quarto export" },
			{ "<leader>qE", ":lua require'otter'.export(true)<cr>", desc = "quarto export overwrite" },
			{ "<leader>qrr", ":QuartoSendAbove<cr>", desc = "quarto run to cursor" },
			{ "<leader>qra", ":QuartoSendAll<cr>", desc = "quarto run all" },
			{ "<leader><cr>", ":SlimeSend<cr>", desc = "send code chunk" },
			{ "<c-cr>", ":SlimeSend<cr>", desc = "send code chunk" },
			{ "<c-cr>", "<esc>:SlimeSend<cr>i", mode = "i", desc = "send code chunk" },
			{ "<c-cr>", "<Plug>SlimeRegionSend<cr>", mode = "v", desc = "send code chunk" },
			{ "<cr>", "<Plug>SlimeRegionSend<cr>", mode = "v", desc = "send code chunk" },
			{ "<leader>cti", ":split term://ipython<cr>", desc = "terminal: ipython" },
			{ "<leader>ctp", ":split term://python<cr>", desc = "terminal: python" },
		},
	},

	{
		"jmbuhr/otter.nvim",
		opts = {
			buffers = {
				set_filetype = true,
			},
		},
	},

	-- send code from python/r/qmd documets to a terminal or REPL
	-- like ipython, R, bash
	{
		"jpalardy/vim-slime",
		init = function()
			vim.b["quarto_is_" .. "python" .. "_chunk"] = false
			Quarto_is_in_python_chunk = function()
				require("otter.tools.functions").is_otter_language_context("python")
			end

			vim.cmd([[
      let g:slime_dispatch_ipython_pause = 100
      function SlimeOverride_EscapeText_quarto(text)
      call v:lua.Quarto_is_in_python_chunk()
      if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk
      return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
      else
      return a:text
      end
      endfunction
      ]])

			local function mark_terminal()
				vim.g.slime_last_channel = vim.b.terminal_job_id
				vim.print(vim.g.slime_last_channel)
			end

			local function set_terminal()
				vim.b.slime_config = { jobid = vim.g.slime_last_channel }
			end

			-- slime, neovvim terminal
			vim.g.slime_target = "neovim"
			vim.g.slime_python_ipython = 1

			require("which-key").register({
				["<leader>cm"] = { mark_terminal, "mark terminal" },
				["<leader>cs"] = { set_terminal, "set terminal" },
			})
		end,
	},
}
