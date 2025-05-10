local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- BASIC SETTINGS
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- LAZY SETUP
require("lazy").setup({
  spec = {
    -- Catppuccin theme
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      config = function()
        require("catppuccin").setup({
          flavour = "macchiato", -- latte, frappe, macchiato, mocha
          integrations = {
            treesitter = true,
            native_lsp = {
              enabled = true,
              virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
              },
            },
          },
        })
        vim.cmd.colorscheme("catppuccin")
      end,
    },

    -- Supermaven
    {
      "supermaven-inc/supermaven-nvim",
      config = function()
        require("supermaven-nvim").setup({})
      end,
    },

    -- Comment.nvim
    {
      "numToStr/Comment.nvim",
      opts = {
        -- options here if needed
      },
    },

    -- Telescope + live grep args
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        {
          "nvim-telescope/telescope-live-grep-args.nvim",
          version = "^1.0.0",
        },
      },
      config = function()
        local telescope = require("telescope")
        telescope.setup({
          defaults = {
            mappings = {
              i = {
                ["<C-h>"] = "which_key"
              }
            }
          }
        })
        telescope.load_extension("live_grep_args")
      end,
    },

    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "lua", "vim", "javascript", "typescript", "python" },  -- Ensure Python parser is included
          highlight = { enable = true },
          indent = { enable = true },
        })
        -- Ensure Python parser is installed
        require("nvim-treesitter.install").compilers = { "gcc" }  -- Make sure you have a working C compiler installed
        vim.cmd("TSInstall python")  -- Install the Python parser if not already installed
      end,
    },

    -- NvimTree
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("nvim-tree").setup({}) 
      end,
    },

    -- LSP setup (TypeScript with ts_ls)
    {
      'neovim/nvim-lspconfig',
      config = function()
        require('lspconfig').ts_ls.setup{}  -- Using ts_ls instead of tsserver
        vim.diagnostic.config({
          virtual_text = true,
          signs = true,
          underline = true,
        })
      end
    },

    -- null-ls setup (for additional linters/formatters like ESLint, Prettier)
    {
      'jose-elias-alvarez/null-ls.nvim',
      config = function()
        local null_ls = require('null-ls')
        null_ls.setup({
          sources = {
            null_ls.builtins.diagnostics.eslint,  -- ESLint for JavaScript
            null_ls.builtins.formatting.prettier, -- Prettier formatter
          },
        })
      end
    },

    -- ALE setup (alternative for non-LSP linters)
    {
      'dense-analysis/ale',
      config = function()
        vim.g.ale_linters = {
          javascript = {'eslint'},
          python = {'flake8'},
        }
        vim.g.ale_fixers = {
          javascript = {'prettier'},
          python = {'black'},
        }
        vim.g.ale_lint_on_text_changed = 'always'
        vim.g.ale_lint_on_insert_leave = 1
      end
    },
  },

  install = {
    colorscheme = { "catppuccin" },
  },
  checker = {
    enabled = true,
  },
})

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

-- Code suggestions popup (Alt+Enter feel)
vim.keymap.set("n", "<A-CR>", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "LSP Code Actions" })

-- Format Document (Shift+Alt+F in VS Code)
vim.keymap.set("n", "<S-A-f>", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "Format Document" })

-- Go to definition (F12)
vim.keymap.set("n", "<F12>", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to Definition" })

-- Rename symbol (F2)
vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename Symbol" })

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
