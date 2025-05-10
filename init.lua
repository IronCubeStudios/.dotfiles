-- KEYMAPS
-- Unmap Ctrl + n (if it's interfering)
vim.api.nvim_set_keymap("n", "<C-n>", "", { noremap = true, silent = true })

vim.o.clipboard = "unnamedplus"

vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>p", '"+p')
vim.keymap.set("v", "<leader>p", '"+p')

-- Custom Keybinding for NvimTree Toggle
vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })

vim.keymap.set("n", "<leader>sg", function()
  require("telescope").extensions.live_grep_args.live_grep_args()
end, { desc = "Live Grep with Args" })

-- === VSCode-LIKE KEYBINDINGS & COMMAND PALETTE === --

-- Telescope command palette like VSCode's Ctrl+Shift+P
vim.keymap.set("n", "<C-S-p>", "<cmd>Telescope commands<CR>", { desc = "Command Palette" })

-- Fuzzy find files (Ctrl+P in VS Code)
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })

-- Search in files (like Ctrl+Shift+F)
vim.keymap.set("n", "<C-S-f>", function()
  require("telescope").extensions.live_grep_args.live_grep_args()
end, { desc = "Live Grep with Args" })

-- Recent files (Ctrl+R)
vim.keymap.set("n", "<C-r>", "<cmd>Telescope oldfiles<CR>", { desc = "Recent Files" })

-- Buffers (Ctrl+B in some themes)
vim.keymap.set("n", "<C-b>", "<cmd>Telescope buffers<CR>", { desc = "Open Buffers" })

-- File Explorer (Ctrl+Shift+E in VS Code)
vim.keymap.set("n", "<C-S-e>", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })

-- === PLUGIN SPECIFIC SHORTCUTS === --

-- Toggle comments (like Ctrl+/ in VS Code)
vim.keymap.set("n", "<C-/>", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle Comment" })

vim.keymap.set("v", "<C-/>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "Toggle Comment Block" })

-- Supermaven toggle suggestion (if supported)
vim.keymap.set("n", "<leader>sm", "<cmd>lua require('supermaven-nvim').toggle()<CR>", { desc = "Toggle Supermaven" })

-- === QUALITY OF LIFE === --

-- Clear search (Esc Esc)
vim.keymap.set("n", "<Esc><Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear Highlight" })

-- Save file (Ctrl+S)
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save File" })

-- Quit file (Ctrl+Q)
vim.keymap.set("n", "<C-q>", "<cmd>q<CR>", { desc = "Quit File" })

-- === LSP SHORTCUTS === --

-- Code suggestions popup (Alt+Enter feel)
vim.keymap.set("n", "<A-CR>", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "LSP Code Actions" })

-- Format Document (Shift+Alt+F in VS Code)
vim.keymap.set("n", "<S-A-f>", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "Format Document" })

-- Go to definition (F12)
vim.keymap.set("n", "<F12>", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to Definition" })

-- Rename symbol (F2)
vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename Symbol" })
