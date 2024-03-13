-- Toogle a terminal session similar to VScode at the bottom

vim.api.nvim_create_user_command("TermToggle", function()
	local is_open = vim.g.term_win_id ~= nil and vim.api.nvim_win_is_valid(vim.g.term_win_id)

	if is_open then
		vim.api.nvim_win_hide(vim.g.term_win_id)
		vim.g.term_win_id = nil
		return
	end

	-- Open new window 25 lines tall at the bottom of the screen
	vim.cmd("botright 25 new")
	vim.g.term_win_id = vim.api.nvim_get_current_win()

	local has_term_buf = vim.g.term_buf_id ~= nil and vim.api.nvim_buf_is_valid(vim.g.term_buf_id)

	if has_term_buf then
		vim.api.nvim_win_set_buf(vim.g.term_win_id, vim.g.term_buf_id)
	else
		vim.cmd.term()
		vim.g.term_buf_id = vim.api.nvim_get_current_buf()
	end

	vim.cmd.startinsert()
end, {})

-- For session manager usage
vim.api.nvim_create_user_command("TermKill", function()
	if vim.g.term_win_id ~= nil then
		vim.api.nvim_win_close(vim.g.term_win_id, true)
		vim.g.term_win_id = nil
	end
	if vim.g.term_buf_id ~= nil then
		vim.api.nvim_buf_delete(vim.g.term_buf_id, { force = true })
		vim.g.term_buf_id = nil
	end
end, {})

-- Toogle in normal mode
vim.keymap.set("n", "<leader>t", vim.cmd.TermToggle, { desc = "Toggle [T]erminal", silent = true })

-- Toogle in terminal mode
vim.keymap.set("t", "<C-t>", vim.cmd.TermToggle, { desc = "Toggle [^][T]erminal", silent = true })
