-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut.
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Faster vertical movements
vim.keymap.set("n", "J", "5j", { desc = "Move down 5 lines." })
vim.keymap.set("n", "K", "5k", { desc = "Move up 5 lines." })
vim.keymap.set("v", "J", "5j", { desc = "Move down 5 lines." })
vim.keymap.set("v", "K", "5k", { desc = "Move up 5 lines." })

--  Use CTRL+<hjkl> to switch between splits
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

--  Use ALT+<hjkl> to switch between tabs
--  See `:help tabpage` for a list of all tab commands
vim.keymap.set("n", "<A-j>", "<cmd>tabnew %<CR>", { desc = "Create a new tab" })
vim.keymap.set("n", "<A-l>", "<cmd>tabNext<CR>", { desc = "Go to the right tab" })
vim.keymap.set("n", "<A-h>", "<cmd>tabprevious<CR>", { desc = "Go to the left tab" })
vim.keymap.set("n", "<A-k>", "<cmd>tabclose<CR>", { desc = "Close current tab" })

-- Toogle wrap
vim.keymap.set("n", "<Leader>l", "<cmd>set wrap!<CR>", { desc = "Toogle line wrap" })
vim.keymap.set("n", "<Leader>ng", "<cmd>Neogit<CR>", { desc = "Open Neogit" })

-- Toggle NeoTree
vim.keymap.set("n", "<C-b>", "<Cmd>Neotree toggle<CR>")

-- Escape insert mode using jk
vim.keymap.set("i", "jk", "<Esc>", { desc = "Use jk key combination to escape the insert mode" })

-- Cut line with X
vim.keymap.set("n", "X", "Vx", { desc = "Cut line" })

-- Move lines up and down
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

-- Increase or decrease indentation
vim.keymap.set("v", "<", "<gv", { desc = "Deindent selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent selection" })

-- Delete instead of cutting, send to the blackhole register _
vim.keymap.set("v", "d", '"_d', { desc = "Delete" })
vim.keymap.set("n", "d", '"_d', { desc = "Delete" })

-- Neogen docstring generation. Run inside a function or class.
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>nc", ":lua require('neogen').generate({ type = 'class' })<CR>", opts)
